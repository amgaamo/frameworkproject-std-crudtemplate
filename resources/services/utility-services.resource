*** Settings ***
Resource    ../commonkeywords.resource
Resource    main-services.resource

*** Keywords ***
Execute API Request
    [Arguments]     ${servicename}                    ${method}                           ${urlpath}                          ${requestbody}        
    ...             ${headers_usession}=${EMPTY}      ${headers_pwdsession}=${EMPTY}      ${headers_type}=headers_simple      ${headers_token}=${EMPTY}    
    ...             ${expectedstatus}=200             ${basic_authen}=None                ${basic_authen_user}=None           ${basic_auth_pwd}=None
    ...             &{custom_headers}
    
    main-services.Create Headers Authen Service
    ...     headeruser=${headers_usession}
    ...     headerpwd=${headers_pwdsession}
    ...     type=${headers_type}
    ...     content-type=application/json
    ...     token=${headers_token}
    ...     &{custom_headers}
    
    main-services.Create Session Service    
    ...    ${servicename}      ${urlpath}  
    ...    ${basic_authen}     ${basic_authen_user}     ${basic_auth_pwd}    
    ...    &{GLOBAL_APIAUTH_HEADERS}   
     
    &{resp_getsession}=    main-services.Request Service Method    ${servicename}    ${method}    ${urlpath}    ${requestbody}    expectedstatus=${expectedstatus}
    
    Log Many    \nRequest Header: ${GLOBAL_REQUEST_HEADERS}    
    Log Many    \nRequest Body: ${GLOBAL_REQUEST_BODY}      
    Log Many    \nResponse: ${RESPONSE_JSON}  
    Set Global Variable    ${GLOBAL_RESPONSE_JSON}       ${RESPONSE_JSON}
