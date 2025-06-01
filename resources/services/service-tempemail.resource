*** Settings ***
Resource   main-services.resource
Resource   utility-services.resource

*** Variables ***
${VAR_BASEURL_TEMPEMAIL}          https://api.mail.tm

${VAR_PATH_DOMAINS}               /domains
${VAR_PATH_TEMPEMAIL_CREATE}      /accounts
${VAR_PATH_TEMPEMAIL_GETTOKEN}    /token
${VAR_PATH_TEMPEMAIL_GETMSG}      /messages


####  The email domain has a time limit. Please use keywords for the receive email function that can be tested immediately. ####

*** Keywords ***
Get Lastest email domail
    [Documentation]    Get the latest email domain from the temp email service.
    utility-services.Execute API Request
    ...    servicename=get_domain
    ...    method=GET
    ...    urlpath=${VAR_BASEURL_TEMPEMAIL}${VAR_PATH_DOMAINS}
    ...    requestbody=None
    ...    headers_type=headers_simple
    ...    expectedstatus=200

    Set Global Variable    ${GLOBAL_RESP_DOMAIN}               ${GLOBAL_RESPONSE_JSON}
    Set Global Variable    ${GLOBAL_RESP_MESSAGE_DOMAIN}       ${GLOBAL_RESP_DOMAIN}[hydra:member]
    Set Global Variable    ${GLOBAL_DOMAIN_TEMPEMAIL}          ${GLOBAL_RESP_MESSAGE_DOMAIN}[0][domain]
    Log To Console         \nEmail Domain: ${GLOBAL_DOMAIN_TEMPEMAIL}

Create New Temp Email Account
    [Arguments]     ${user_email}    ${password}
    Get Lastest email domail
    utility-services.Execute API Request
    ...    servicename=create_tempemail
    ...    method=POST
    ...    urlpath=${VAR_BASEURL_TEMPEMAIL}${VAR_PATH_TEMPEMAIL_CREATE}
    ...    requestbody={"address":"${user_email}@${GLOBAL_DOMAIN_TEMPEMAIL}","password":"${password}"}
    ...    headers_type=headers_simple
    ...    expectedstatus=201

    Set Global Variable    ${RESPONSE_CREATE_TEMP_EMAIL}       ${GLOBAL_RESPONSE_JSON}
Login Temp Email Account
    [Arguments]     ${user_email}    ${password}
    Get Lastest email domail
    utility-services.Execute API Request
    ...    servicename=login_tempemail
    ...    method=POST
    ...    urlpath=${VAR_BASEURL_TEMPEMAIL}${VAR_PATH_TEMPEMAIL_GETTOKEN}
    ...    requestbody={"address":"${user_email}@${GLOBAL_DOMAIN_TEMPEMAIL}","password":"${password}"}
    ...    headers_type=headers_simple
    ...    expectedstatus=200
    
    Set Global Variable    ${GLOBAL_TEMP_EMAIL_TOKEN}       ${GLOBAL_RESPONSE_JSON}[token]
    Set Global Variable    ${GLOBAL_TEMP_EMAIL_ID}          ${GLOBAL_RESPONSE_JSON}[id]

Get Message from Temp Email Account
    [Arguments]     ${user_email}    ${password}
    Login Temp Email Account    ${user_email}    ${password}
    utility-services.Execute API Request
    ...    servicename=get_tempemail
    ...    method=GET
    ...    urlpath=${VAR_BASEURL_TEMPEMAIL}${VAR_PATH_TEMPEMAIL_GETMSG}
    ...    requestbody=None
    ...    headers_type=headers_auth_bearer
    ...    token=${GLOBAL_TEMP_EMAIL_TOKEN}
    ...    expectedstatus=200
    
    Set Global Variable    ${GLOBAL_RESP_MESSAGE_ALL}              ${GLOBAL_RESPONSE_JSON}
    Set Global Variable    ${GLOBAL_RESP_MESSAGE_TOTALITEMS}       ${GLOBAL_RESP_MESSAGE_ALL}[hydra:totalItems]
    Set Global Variable    ${GLOBAL_RESP_MESSAGE_EMAIL}            ${GLOBAL_RESP_MESSAGE_ALL}[hydra:member]

Wait for Email to Arrive
    [Arguments]    ${user_email}    ${password}    ${time_wait}=90
    
    ${time_wait}=   Evaluate    expression=${time_wait}/5
    FOR    ${index}    IN RANGE    ${time_wait}
       Get Message from Temp Email Account    ${user_email}    ${password}
       ${GLOBAL_RESP_MESSAGE_TOTALITEMS}=   Convert To Integer    ${GLOBAL_RESP_MESSAGE_TOTALITEMS}
       Exit For Loop If    ${GLOBAL_RESP_MESSAGE_TOTALITEMS} > 0
       Log To Console    \nWaiting for Email to Arrive delay 5s
       Sleep    5s     
    END
    
Get Email ID Latest Message from Temp Email Account
    [Arguments]     ${user_email}    ${password}    
    
    Wait for Email to Arrive    ${user_email}    ${password}   

    IF  ${GLOBAL_RESP_MESSAGE_TOTALITEMS} == 0
        Log To Console    \nNo Email Arrived
        Fail    No Email Arrived
    ELSE
        ${latest_msgid}=    Set Variable    ${GLOBAL_RESP_MESSAGE_EMAIL}[0][id]
        Set Global Variable    ${GLOBAL_RESP_MESSAGE_LATEST}    ${latest_msgid}
    END


Get Email Content Latest Message from Temp Email Account
    [Arguments]     ${user_email}    ${password}    ${data_tag}=text
    
    Wait for Email to Arrive    ${user_email}    ${password}   

    IF  ${GLOBAL_RESP_MESSAGE_TOTALITEMS} == 0
        Log To Console    \nNo Email Arrived
        Fail    No Email Arrived
    ELSE
        ${latest_msgid}=    Set Variable    ${GLOBAL_RESP_MESSAGE_EMAIL}[0][id]
        # main-services.Request Service Method    get_tempemail    GET    ${VAR_PATH_TEMPEMAIL_GETMSG}/${latest_msgid}      requestbody=None
        
        utility-services.Execute API Request
        ...    servicename=get_tempemail_content
        ...    method=GET
        ...    urlpath=${VAR_BASEURL_TEMPEMAIL}${VAR_PATH_TEMPEMAIL_GETMSG}/${latest_msgid}
        ...    requestbody=None    
        ...    headers_type=headers_auth_bearer
        ...    token=${GLOBAL_TEMP_EMAIL_TOKEN}
        ...    expectedstatus=200
        
        Set Global Variable    ${GLOBAL_RESP_MSG_CONTENT_LATEST}    ${GLOBAL_RESPONSE_JSON}[${data_tag}]
        Log Many     ${GLOBAL_RESP_MSG_CONTENT_LATEST}
    END

