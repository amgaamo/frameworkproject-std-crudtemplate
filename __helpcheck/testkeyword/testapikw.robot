*** Settings ***
Resource          ../../resources/commonkeywords.resource

*** Variables ***

${url_basicauth}    https://postman-echo.com/basic-auth
${url_noauth}       https://restful-booker.herokuapp.com/booking?firstname=sally&lastname=brown
${url_apitest}      https://restful-booker.herokuapp.com/auth
${url_authtest}     https://authenticationtest.com/HTTPAuth/
&{userbasicauth}    username=postman      password=password
&{userapi}          username=admin        password=password123


*** Test Cases ***
Request Service Browser not open
    Request Service No Authentication
    commonkeywords.Release user lock and close all browser
    Request Basic Authentication
    commonkeywords.Release user lock and close all browser
    Request No Basic Authen for method GET

Request Service Browser already Open
    commonkeywords.Open Browser and Go to website      https://authenticationtest.com/
    Request Basic Authentication
    commonkeywords.Verify Button State    //*[@href="https://authenticationtest.com/complexAuth/"]      visible
    Request Basic Authen in authenticationtest Site

Request Service Browser already Open Same domain
    commonkeywords.Open Browser and Go to website         https://restful-booker.herokuapp.com/
    Request Basic Authentication
    commonkeywords.Verify Button State    //*[contains(text(),'Mark Winteringham')]    visible
    Request No Basic Authen for method GET
    commonkeywords.Verify Button State    //*[contains(text(),'Mark Winteringham')]    visible
    Request Service No Authentication
    commonkeywords.Verify Button State    //*[contains(text(),'Mark Winteringham')]    visible


Request Service Browser already Open - Same domain and other domain
    commonkeywords.Open Browser and Go to website         https://restful-booker.herokuapp.com/
    Request Basic Authentication
    commonkeywords.Verify Button State    //*[contains(text(),'Mark Winteringham')]    visible
    Request No Basic Authen for method GET
    commonkeywords.Verify Button State    //*[contains(text(),'Mark Winteringham')]    visible
    Request Service No Authentication
    commonkeywords.Verify Button State    //*[contains(text(),'Mark Winteringham')]    visible

*** Keywords ***
Request Service No Authentication
    main-services.Create Session Request Service    ${url_apitest}
    main-services.Create Headers Authen Service

    ${bodydata}=    Catenate    {"username": "${userapi.username}", "password": ${userapi.password}}
    &{resp_noauth}=   HTTP    ${url_apitest}    method=POST   body=${bodydata}    headers=${GLOBAL_APIAUTH_HEADERS}

    main-services.Close Session Request Service and switch to main page   ${url_apitest}

Request No Basic Authen for method GET
    main-services.Create Session Request Service    ${url_noauth}
    main-services.Create Headers Authen Service

    ${rest_getmethod}=    HTTP    ${url_noauth}     method=GET

    main-services.Close Session Request Service and switch to main page     ${url_apitest}

Request Basic Authentication
    main-services.Create Session Request Service        url=${url_basicauth}      is_credentials=true    username_auth=${userbasicauth.username}     password_auth=${userbasicauth.password}
    main-services.Create Headers Authen Service
    &{resp_basicauth}=       HTTP       ${url_basicauth}      method=GET     headers=${GLOBAL_APIAUTH_HEADERS}

    Set Local Variable    ${statuscode_res}         ${resp_basicauth.status}
    Should Be Equal      '${statuscode_res}'       '200'
    main-services.Close Session Request Service and switch to main page     ${url_basicauth}

Request Basic Authen in authenticationtest Site
    main-services.Create Session Request Service        url=${url_authtest}      is_credentials=true    username_auth=user    password_auth=pass
    main-services.Create Headers Authen Service
    &{resp_basicauth}=       HTTP       ${url_authtest}      method=GET     headers=${GLOBAL_APIAUTH_HEADERS}
    main-services.Close Session Request Service and switch to main page     ${url_authtest}