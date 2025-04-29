*** Settings ***
Resource    main-services.resource
Library    RPA.PDF

*** Variables ***
${VAR_BASEURL_TEMPEMAIL}          https://api.mail.tm

${VAR_PATH_DOMAINS}               /domains
${VAR_PATH_TEMPEMAIL_CREATE}      /accounts
${VAR_PATH_TEMPEMAIL_GETTOKEN}    /token
${VAR_PATH_TEMPEMAIL_GETMSG}      /messages


####  The email domain has a time limit. Please use keywords for the receive email function that can be tested immediately. ####

*** Keywords ***
Get Lastest email domail
    main-services.Create Headers Authen Service
    &{headers}=     Set Variable      ${GLOBAL_APIAUTH_HEADERS}
    main-services.Create Session Service    get_domain    ${VAR_BASEURL_TEMPEMAIL}    &{headers}

    main-services.Request Service Method    get_domain    GET    ${VAR_PATH_DOMAINS}      requestbody=None
    Status Should Be       expected_status=200

    Set Global Variable    ${GLOBAL_RESP_DOMAIN}               ${RESPONSE_JSON}
    Set Global Variable    ${GLOBAL_RESP_MESSAGE_DOMAIN}       ${GLOBAL_RESP_DOMAIN}[hydra:member]
    Set Global Variable    ${GLOBAL_DOMAIN_TEMPEMAIL}             ${GLOBAL_RESP_MESSAGE_DOMAIN}[0][domain]
    Log To Console         \nEmail Domain: ${GLOBAL_DOMAIN_TEMPEMAIL}

Create New Temp Email Account
    [Arguments]     ${user_email}    ${password}
    main-services.Create Headers Authen Service
    &{headers}=     Set Variable      ${GLOBAL_APIAUTH_HEADERS}
    main-services.Create Session Service    create_tempemail   ${VAR_BASEURL_TEMPEMAIL}       &{headers}

    ${bodydata}=    Set Variable    {"address":"${user_email}@${GLOBAL_DOMAIN_TEMPEMAIL}","password":"${password}"}
    main-services.Request Service Method    create_tempemail    POST    ${VAR_PATH_TEMPEMAIL_CREATE}  ${bodydata}    expectedstatus=201
    Set Global Variable    ${RESPONSE_CREATE_TEMP_EMAIL}       ${RESPONSE_JSON}

Login Temp Email Account
    [Arguments]     ${user_email}    ${password}
    main-services.Create Headers Authen Service
    &{headers}=     Set Variable      ${GLOBAL_APIAUTH_HEADERS}
    main-services.Create Session Service    login_tempemail    ${VAR_BASEURL_TEMPEMAIL}    &{headers}

    ${bodydata}=    Set Variable    {"address":"${user_email}@${GLOBAL_DOMAIN_TEMPEMAIL}","password":"${password}"}
    main-services.Request Service Method    login_tempemail    POST    ${VAR_PATH_TEMPEMAIL_GETTOKEN}    ${bodydata}     

    Set Global Variable    ${GLOBAL_TEMP_EMAIL_TOKEN}       ${RESPONSE_JSON}[token]
    Set Global Variable    ${GLOBAL_TEMP_EMAIL_ID}          ${RESPONSE_JSON}[id]

Get Message from Temp Email Account
    [Arguments]     ${user_email}    ${password}

    Login Temp Email Account    ${user_email}    ${password}
    main-services.Create Headers Authen Service    type=headers_auth_bearer       token=${GLOBAL_TEMP_EMAIL_TOKEN}    
    
    &{headers}=     Set Variable      ${GLOBAL_APIAUTH_HEADERS}
    main-services.Create Session Service    get_tempemail    ${VAR_BASEURL_TEMPEMAIL}    &{headers}

    main-services.Request Service Method    get_tempemail    GET    ${VAR_PATH_TEMPEMAIL_GETMSG}      requestbody=None
    Status Should Be       expected_status=200

    Set Global Variable    ${GLOBAL_RESP_MESSAGE_ALL}              ${RESPONSE_JSON}
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
        main-services.Request Service Method    get_tempemail    GET    ${VAR_PATH_TEMPEMAIL_GETMSG}/${latest_msgid}      requestbody=None
        Set Global Variable    ${GLOBAL_RESP_MSG_CONTENT_LATEST}    ${RESPONSE_JSON}[${data_tag}]
        Log Many     ${GLOBAL_RESP_MSG_CONTENT_LATEST}
    END

