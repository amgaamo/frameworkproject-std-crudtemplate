*** Settings ***
Resource    ../../resources/commonkeywords.resource
Resource    ../../resources/services/utility-services.resource


*** Test Cases ***     
Test Call API Service Using UID/UCODE
    Call API Service Get Session
    Set Test Variable       ${USER_UID}    ${GLOBAL_RESPONSE_JSON}[data][data][uid]
    Set Test Variable       ${USER_UCODE}  ${GLOBAL_RESPONSE_JSON}[data][data][ucode]
    &{headers_uiducode}=    Create Dictionary       Content-Type=application/json       uid=${USER_UID}    ucode=${USER_UCODE}
    utility-services.Execute API Request
    ...    servicename=service_searchuser
    ...    method=POST
    ...    urlpath=https://demoinvoicechain.netbay.co.th/RD_SERVICE_PROVIDER_TRACKING/user/ibox/search
    ...    requestbody={"pageNum":1,"pageSize":10,"order":[{"name":"createdAt","asc":false}],"search":{"text":"kwan","cpId":"59140253e869aa48131fe45c"}}
    ...    headers_type=custom_headers
    ...    expectedstatus=200
    ...    &{headers_uiducode}

Test Call API Service Using UID/UCODE 2
    Call API Service Get Session
    Set Test Variable       ${USER_UID}    ${GLOBAL_RESPONSE_JSON}[data][data][uid]
    Set Test Variable       ${USER_UCODE}  ${GLOBAL_RESPONSE_JSON}[data][data][ucode]
    &{headers_uiducode}=    Create Dictionary       Content-Type=application/json       uid=${USER_UID}    ucode=${USER_UCODE}
    utility-services.Execute API Request
    ...    servicename=service_searchdocType
    ...    method=POST
    ...    urlpath=https://demoinvoicechain.netbay.co.th/rd-sp-server-tracking/esignatureConfig/docType/search
    ...    requestbody={"order":[{"name":"createdAt","asc":false}],"pageNum":1,"pageSize":10,"search":{"cpId":"59140253e869aa48131fe45c","docTypeName":"ตราสารทดสอบ100","enable":null}}
    ...    headers_type=custom_headers
    ...    expectedstatus=200
    ...    &{headers_uiducode}

    Log    \n${RESPONSE_JSON}[data][data][0][docTypeName]    console=True

*** Keywords ***
Call API Service Get Session
      utility-services.Execute API Request
      ...     servicename=service_getsession  
      ...     method=POST
      ...     urlpath=https://demoinvoicechain.netbay.co.th/RD_SERVICE_PROVIDER_TRACKING/public/login-getsession
      ...     requestbody={"username":"nattawut@netbay.co.th","password":"Netbay@123"}
      ...     headers_type=headers_simple
      ...     expectedstatus=200