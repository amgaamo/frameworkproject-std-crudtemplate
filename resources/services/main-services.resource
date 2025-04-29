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
   [Arguments]    ${headeruser}=${EMPTY}    ${headerpwd}=${EMPTY}     ${type}=headers_simple     ${content-type}=application/json    ${token}=${EMPTY}

    # IF  '${type}'=='headers_authuser'
    #       Request Service Get Session Data    ${headeruser}       ${headerpwd}
    #       ${GLOBAL_APIAUTH_HEADERS}=          Create Dictionary        Content-Type=${content-type}       uid=${GLOBAL_APIUID}      ucode=${GLOBAL_APIUCODE}
    
    IF   '${type}'=='headers_authuser_reqlib'
          Request Service RequestLib Get Session Data    ${headeruser}       ${headerpwd}
          ${GLOBAL_APIAUTH_HEADERS}=          Create Dictionary        Content-Type=${content-type}       uid=${GLOBAL_APIUID}      ucode=${GLOBAL_APIUCODE}

    ELSE IF   '${type}'=='headers_simple'
          ${GLOBAL_APIAUTH_HEADERS}=          Create Dictionary        Content-Type=${content-type}
    
    ELSE IF   '${type}'=='headers_auth_bearer'
          ${GLOBAL_APIAUTH_HEADERS}=          Create Dictionary        Content-Type=${content-type}       Authorization=Bearer ${token}
    ELSE
        Fail    \nPlease Check type arg. should any 'headers_ucode' or 'headers_simple' or 'headers_auth_bearer'
    END

    Set Global Variable            ${GLOBAL_APIAUTH_HEADERS}


###---------------------------------------------------------###
#       Keywords for Requests HTTP by Browser Lib             #
###---------------------------------------------------------###

# Create Session Request Service
#     [Arguments]     ${url}      ${is_credentials}=false    ${username_auth}=${EMPTY}    ${password_auth}=${EMPTY}

#       ${browserIds}=        Get Browser Ids    ALL
#       ${browserIds_notexist}=    Run Keyword And Return Status     Should Be True        '${browserIds}'=='[]'

#       IF  '${browserIds_notexist}'=='False'
#           commonkeywords.Get MAIN pageids for switch page
#           ${current_url}=        Get Url
#           ${current_url}=        Get Regexp Matches               ${current_url}        ([^\/]+\.[^\/]+)
#           ${current_url}=        Remove String Using Regexp       ${current_url}[1]     /[^\/]+

#           ${request_url}=        Get Regexp Matches               ${url}                ([^\/]+\.[^\/]+)
#           ${request_url}=        Remove String Using Regexp       ${request_url}[1]     /[^\/]+

#           ${is_samereq_url}=     Run Keyword And Return Status     Should Be Equal     ${request_url}     ${current_url}

#           IF  '${is_samereq_url}'=='True' and '${is_credentials}'=='false'
#               Log To Console    \nBrowser is open and the same url domain.
#           ELSE
#               commonkeywords.Get MAIN pageids for switch page
#               Open New Browser for http request    ${url}     ${is_credentials}    ${username_auth}    ${password_auth}
#               commonkeywords.Get Information New Page Open
#               commonkeywords.Switch Another Open Page    ${GLOBAL_NEWPAGE}
#           END
#       ELSE
#           Open New Browser for http request    ${url}     ${is_credentials}    ${username_auth}    ${password_auth}
#       END


# Open New Browser for http request
#     [Arguments]   ${url}     ${is_credentials}   ${username_auth}    ${password_auth}
#       Run Keyword If   '${VAR_BROWSER}'=='chrome'     New Browser     browser=chromium    headless=${_headlessmode_}    channel=chrome
#       ...    ELSE IF   '${VAR_BROWSER}'=='msedge'     New Browser     browser=chromium    headless=${_headlessmode_}    channel=msedge
#       ...    ELSE IF   '${VAR_BROWSER}'=='chromium'   New Browser     browser=chromium    headless=${_headlessmode_}
#       ...    ELSE IF   '${VAR_BROWSER}'=='firefox'    New Browser     browser=firefox     headless=${_headlessmode_}

#       Sleep    1500ms

#       IF  '${is_credentials}'=='false'
#           New Context        ignoreHTTPSErrors=True
#       ELSE IF  '${is_credentials}'=='true'
#           ${credentials}=    Create Dictionary           username=$username_auth     password=$password_auth
#           New Context        ignoreHTTPSErrors=True      httpCredentials=${credentials}
#       ELSE
#           Fail    \nPlease Check $is_credentials arg. should any 'true' or 'false'
#       END

#       New Page
#       Go To       ${url}
#       Set Viewport Size     1280    760
#       Sleep    1s

# Close Session Request Service and switch to main page
#     [Arguments]     ${url}
#       ${mainpageIds_is_exist}=      Run Keyword And Return Status    Should Be True     '${GLOBAL_MAINPAGE}'!=''
#       ${current_url}=               Get Url
#       ${is_sameurl}=                Run Keyword And Return Status    Should Be True     '${url}'=='${current_url}'

#       IF  '${mainpageIds_is_exist}'=='True' and '${is_sameurl}'=='False'
#           commonkeywords.Switch Another Open Page    ${GLOBAL_MAINPAGE}
#       ELSE IF  '${mainpageIds_is_exist}'=='True' and '${is_sameurl}'=='True'
#           Close Page
#           Sleep    700ms
#           Log To Console    \nClose Session Request Success.
#           Switch Another Open Page    ${GLOBAL_MAINPAGE} 
#       ELSE
#         #   Close Page
#         #   Sleep    700ms
#           Log To Console    \nClose Session Request Success.
#       END

# Request Service Get Session Data
#     [Arguments]     ${username}     ${password}

#     Set Path Request URL
#     Create Session Request Service    ${SERVICE_GETSESSION_PATH}

#     ${bodydata}=    Catenate       {"username": "${username}", "password": "${password}"}

#     &{resp_getsession}=       HTTP     ${SERVICE_GETSESSION_PATH}     method=POST       body=${bodydata}

#     Set Local Variable        ${status_val}       ${resp_getsession.body.status}
#     Should Be Equal           ${status_val}       success

#     Run Keyword If    '${status_val}'=='success'
#     ...               Run Keywords        Set Global Variable         ${GLOBAL_APIUID}         ${resp_getsession.body.data.uid}
#     ...               AND                 Set Global Variable         ${GLOBAL_APIUCODE}       ${resp_getsession.body.data.ucode}
#     ...               AND                 Set Global Variable         ${GLOBAL_APIUSERNAME}    ${resp_getsession.body.data.username}
#     ...               AND                 Set Global Variable         ${GLOBAL_APICPID}        ${resp_getsession.body.data.cpid}
#     ...               AND                 Set Global Variable         ${GLOBAL_APIGID}         ${resp_getsession.body.data.gid}
#     ...       ELSE    Fail                Please check request service get session keyword!

#     Close Session Request Service and switch to main page    ${SERVICE_GETSESSION_PATH}


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
