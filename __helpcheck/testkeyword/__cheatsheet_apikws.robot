*** Settings ***
Resource          ../../resources/commonkeywords.resource
Resource          ../../resources/utilitykeywords.resource
Resource          ../../resources/services/utility-services.resource

*** Variables ***
${url_basicauth}    https://postman-echo.com/basic-auth
${url_noauth}       https://restful-booker.herokuapp.com/booking/258
${url_apitest}      https://restful-booker.herokuapp.com/auth
${url_helpcheck}    https://practice.expandtesting.com/api/health-check
${url_parkcal}      https://practice.expandtesting.com/webpark/calculate-cost

&{userbasicauth}    username=postman      password=password
&{userapi}          username=admin        password=password123

*** Test Cases ***
Test Call API Service
    Request Service No Authentication
    Request No Basic Authen for method GET
    Request Basic Authentication
    Request helpcheck API service
    Request service using content-type x-www-form-urlencoded 

*** Keywords ***
Request Service No Authentication
    ${bodydata}=    Catenate    {"username": "${userapi.username}", "password": "${userapi.password}"}
    utility-services.Execute API Request    
    ...    servicename=loginws    method=POST   urlpath=${url_apitest}    
    ...    requestbody=${bodydata}
    Log    \ntoken:${GLOBAL_RESPONSE_JSON}[token]     console=True   

Request No Basic Authen for method GET
    utility-services.Execute API Request
    ...    servicename=service_noauth    method=GET   urlpath=${url_noauth}    requestbody=${EMPTY}
    
    Log   \nFirstname:${GLOBAL_RESPONSE_JSON}[firstname]    console=True
    ${checkindata}=     Set Variable       ${GLOBAL_RESPONSE_JSON}[bookingdates]
    Log   \nCheckin:${checkindata}[checkin] \nCheckout:${checkindata}[checkout]     console=True

Request Basic Authentication
    utility-services.Execute API Request
    ...    servicename=service_basicauth    method=GET   urlpath=${url_basicauth}    
    ...    requestbody=${EMPTY}    
    ...    basic_authen=basic_auth    basic_authen_user=${userbasicauth.username}    basic_auth_pwd=${userbasicauth.password}

    Log   \nStatus Authen:${GLOBAL_RESPONSE_JSON}[authenticated]  console=True

Request helpcheck API service
    utility-services.Execute API Request
    ...    servicename=helpcheckapi   method=GET    urlpath=${url_helpcheck}    
    ...    requestbody=${EMPTY}
    
    Log    message: ${GLOBAL_RESPONSE_JSON}[message]    console=True

Request service using content-type x-www-form-urlencoded 
    ${bodydata}=    Catenate    parkType=LongTermGarage&entryDate=2025-06-01T01%3A03&exitDate=2025-06-14T01%3A30
    &{headers}=     Create Dictionary    Content-Type=application/x-www-form-urlencoded

    utility-services.Execute API Request
    ...    servicename=parking calculator   method=POST    urlpath=${url_parkcal}    
    ...    requestbody=${bodydata}    
    ...    headers_type=custom_headers
    ...    &{headers}
    
    Should Be Equal    '${GLOBAL_RESPONSE_JSON}[cost]'    '144'