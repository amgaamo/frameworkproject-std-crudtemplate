*** Settings ***
Resource    service-profile.resource

*** Variables ***
${VAR_PATH_LOGIN}                 users/login
${VAR_PATH_GETSESSION}            users/getsession
${VAR_PATH_LOGOUT}                users/logout

${VAR_PATH_TEMPEMAIL_CREATE}      https://api.mail.tm/accounts
${VAR_PATH_TEMPEMAIL_GETTOKEN}    https://api.mail.tm/token
${VAR_PATH_TEMPEMAIL_GETMSG}      https://api.mail.tm/messages

*** Keywords ***
Set Path Request URL
    resourcekeywords.Set Data for Run Automated Test
    Set Global Variable         ${SERVICE_LOGINUSER_PATH}         ${URLTEST}/${API_URLPATH_TEST}/${VAR_PATH_LOGIN}
    Set Global Variable         ${SERVICE_GETSESSION_PATH}        ${URLTEST}/${API_URLPATH_TEST}/${VAR_PATH_GETSESSION}
    Set Global Variable         ${SERVICE_LOGOUT_PATH}            ${URLTEST}/${API_URLPATH_TEST}/${VAR_PATH_LOGOUT}

Create Headers Authen Service
   [Arguments]    ${headeruser}=${EMPTY}    ${headerpwd}=${EMPTY}     ${type}=headers_simple     ${content-type}=application/json    ${token}=${EMPTY}        &{custom_headers}

    IF   '${type}'=='headers_authuser'
          Request Service RequestLib Get Session Data    ${headeruser}       ${headerpwd}
          ${GLOBAL_APIAUTH_HEADERS}=          Create Dictionary        Content-Type=${content-type}       uid=${GLOBAL_APIUID}      ucode=${GLOBAL_APIUCODE}

    ELSE IF   '${type}'=='headers_simple'
          ${GLOBAL_APIAUTH_HEADERS}=          Create Dictionary        Content-Type=${content-type}
    
    ELSE IF   '${type}'=='headers_auth_bearer'
          ${GLOBAL_APIAUTH_HEADERS}=          Create Dictionary        Content-Type=${content-type}       Authorization=Bearer ${token}
    ELSE IF   '${type}'=='custom_headers'
          ${GLOBAL_APIAUTH_HEADERS}=          Create Dictionary        &{custom_headers}
    ELSE
        Fail    \nPlease Check type arg. should any 'headers_ucode' or 'headers_simple' or 'headers_auth_bearer or 'custom_headers'!
    END

    Set Global Variable            ${GLOBAL_APIAUTH_HEADERS}


###---------------------------------------------------------###
#       Keywords for RequestsLibrary Library                  #
###---------------------------------------------------------###

Create Session Service
    [Arguments]      ${servicename}       ${baseurl}       ${authen}=None     ${authusername}=None       ${authpassword}=None        &{headers_data}
       
    IF  '${authen}'=='None'
        Create Session    ${servicename}    ${baseurl}     headers=&{headers_data}    disable_warnings=1

    ELSE IF   '${authen}'=='basic_auth'
        Should Be True    '${authusername}'!='None'
        Should Be True    '${authpassword}'!='None'

        @{authinfo}=      Create List       ${authusername}        ${authpassword}
        Create Session    ${servicename}    ${baseurl}      auth=${authinfo}      headers=&{headers_data}    disable_warnings=1
    END

Request Service Method
    [Arguments]    ${servicename}   ${method}   ${urlpath}     ${requestbody}     ${expectedstatus}=200
    
    IF    '${method}'=='GET'
        ${response}=        GET On Session     ${servicename}      ${urlpath}       expected_status=${expectedstatus}   
    ELSE IF    '${method}'=='POST'
        ${response}=        POST On Session    ${servicename}      ${urlpath}       ${requestbody}     expected_status=${expectedstatus}   
    END
    
    ${response_content}=     Set Variable    ${response.headers}[Content-Type]
    ${response_content}=     Split String    ${response_content}    ;
    ${response_content}=     Set Variable    ${response_content}[0]

    IF    '${response_content}' in 'application/json'
        ${responsedata}=       Set Variable          ${response.json()}
        Set Global Variable    ${RESPONSE_JSON}      ${responsedata}
    
    ELSE IF  '${response_content}' in 'application/ld+json'
        ${responsedata}=       Set Variable          ${response.json()}
        Set Global Variable    ${RESPONSE_JSON}      ${responsedata}
    ELSE
        Log To Console        \nResponse body is not JSON Format.
    END
    
    Set Global Variable    ${GLOBAL_REQUEST_HEADERS}    ${response.request.headers}
    Set Global Variable    ${GLOBAL_REQUEST_BODY}       ${response.request.body}
    Log    \nRequest Headers: ${response.request.headers}\nRequest Body: ${response.request.body}

Request Service RequestLib Get Session Data
    [Arguments]     ${username}     ${password}

    Set Path Request URL
    Create Headers Authen Service
    ${bodydata}=    Catenate       {"username": "${username}", "password": "${password}"}
    Create Session Service    session_req    ${SERVICE_GETSESSION_PATH}       &{GLOBAL_APIAUTH_HEADERS}
    &{resp_getsession}=       Request Service Method    session_req    POST    ${SERVICE_GETSESSION_PATH}    ${bodydata}

    Set Local Variable        ${status_val}       ${RESPONSE_JSON}[status]
    Should Be Equal           ${status_val}       success

    Run Keyword If    '${status_val}'=='success'
    ...               Run Keywords        Set Global Variable         ${GLOBAL_APIUID}         ${RESPONSE_JSON}[data][uid]
    ...               AND                 Set Global Variable         ${GLOBAL_APIUCODE}       ${RESPONSE_JSON}[data][ucode]
    ...               AND                 Set Global Variable         ${GLOBAL_APIUSERNAME}    ${RESPONSE_JSON}[data][username]
    ...               AND                 Set Global Variable         ${GLOBAL_APICPID}        ${RESPONSE_JSON}[data][cpid]
    ...               AND                 Set Global Variable         ${GLOBAL_APIGID}         ${RESPONSE_JSON}[data][gid]
    ...       ELSE    Fail                Please check request service get session keyword!
