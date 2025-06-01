*** Settings ***
Resource    ../commonkeywords.resource

*** Keywords *** 
# ---- RequestsLibrary ---- #
Request Service Logout System (RequestLib)
    [Arguments]     ${username}     ${password}
      main-services.Set Path Request URL
      main-services.Create Headers Authen Service      ${username}      ${password}     headers_authuser
      &{headers}=     Set Variable      ${GLOBAL_APIAUTH_HEADERS}

      main-services.Create Session Service    logout   ${URLTEST}    &{headers}

      ${bodydata}=        Set Variable      {}
      &{resp_logout}=     main-services.Request Service Method    logout   POST    ${SERVICE_LOGOUT_PATH}      ${bodydata}    

      Set Local Variable        ${status_val}       ${RESPONSE_JSON}[status]
      Should Be Equal           ${status_val}       success