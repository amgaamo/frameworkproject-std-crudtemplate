*** Settings ***
Resource          ../../resources/commonkeywords.resource

*** Variables ***
${url_basicauth}    https://postman-echo.com/basic-auth
${url_noauth}       https://restful-booker.herokuapp.com/booking/1
${url_apitest}      https://restful-booker.herokuapp.com/auth
${url_authtest}     https://authenticationtest.com/HTTPAuth/
&{userbasicauth}    username=postman      password=password
&{userapi}          username=admin        password=password123

*** Test Cases ***
Test Fill out data form
    Open Browser and Go to Web Site Test    https://letcode.in/forms
    Fill out mass field data form   

Test Verify data form
    Open Browser and Go to Web Site Test    https://letcode.in/forms
    Fill out mass field data form   
    Verify mass field data form    

Test Verify result data table
    Open Browser and Go to Web Site Test    https://letcode.in/advancedtable
    Verify result data table with thead table
    commonkeywords.Release user lock and close all browser
    Open Browser and Go to Web Site Test    https://www.techlistic.com/p/demo-selenium-practice.html
    Verify result data table without thead table
    commonkeywords.Release user lock and close all browser
    Open Browser and Go to Web Site Test    https://datatables.net/examples/styling/stripe.html
    commonkeywords.Fill in search field     //*[@id="example_filter"]/label/input    Gavin Cortez
    Sleep    750ms
    Verify result data table with interaction table    Gavin Cortez    Team Leader    	San Francisco    22

Test Call API Service
    Request Service No Authentication
    Request No Basic Authen for method GET
    Request Basic Authentication
    Request Basic Authen in authenticationtest Site

Test Call Get Session
    Request Service RequestLib Get Session Data    admin    Netbay@123

*** Keywords ***
Open Browser and Go to Web Site Test
    [Arguments]    ${url}
      commonkeywords.Open Browser and Go to website          ${url}
Fill out mass field data form   
      @{datafield}=    Create List     firstname    lastname     email     countrycode    country    gender  agreement      
      commonkeywords.Fill out data in form    @{datafield}
      ...     locator.firstname=//*[@id="firstname"]                                                     value.firstname=Suphanaya                   selattr.firstname=${EMPTY}
      ...     locator.lastname=//*[@id="lasttname"]                                                      value.lastname=Nadeena                      selattr.lastname=${EMPTY}
      ...     locator.email=//*[@id="email"]                                                             value.email=testchanchai@mail.com           selattr.email=${EMPTY}
      ...     locator.countrycode=//div[@class="card-content"]/form/div[2]/div[2]/div/div/div/select     value.countrycode=66                        selattr.countrycode=value   
      ...     locator.country=//div[@class="card-content"]/form/div[5]/div[2]/div/div/div/select         value.country=Aruba                         selattr.country=label      
      ...     locator.gender=//*[@id="male"]                                                             value.gender=True                           selattr.gender=${EMPTY}     
      ...     locator.agreement=//label[@class="checkbox"]/input                                         value.agreement=check                       selattr.agreement=${EMPTY}
      
Verify mass field data form
      @{datafield}=    Create List     firstname    lastname     email     countrycode    country     gender  agreement         
      commonkeywords.Verify data form is correct   @{datafield}
      ...     locator.firstname=//*[@id="firstname"]                                                     assert.firstname=should be        expected.firstname=Suphanaya               selattr.firstname=${EMPTY}
      ...     locator.lastname=//*[@id="lasttname"]                                                      assert.lastname=should be         expected.lastname=Nadeena                  selattr.lastname=${EMPTY}
      ...     locator.email=//*[@id="email"]                                                             assert.email=should be            expected.email=testchanchai@mail.com       selattr.email=${EMPTY}
      ...     locator.countrycode=//div[@class="card-content"]/form/div[2]/div[2]/div/div/div/select     assert.countrycode=should be      expected.countrycode=66                    selattr.countrycode=value
      ...     locator.country=//div[@class="card-content"]/form/div[5]/div[2]/div/div/div/select         assert.country=should be          expected.country=Aruba                     selattr.country=label   
      ...     locator.gender=//*[@id="male"]                                                             assert.gender=should be           expected.gender=True                       selattr.gender=${EMPTY}     
      ...     locator.agreement=//label[@class="checkbox"]/input                                         assert.agreement=should be        expected.agreement=check                   selattr.agreement=${EMPTY}

Verify result data table with thead table
      commonkeywords.Verify Result of data table
      ...     locator_thead=//*[@id="advancedtable"]/thead    locator_tbody=//*[@id="advancedtable"]/tbody     rowdata=all   ignorcase=true
      ...     col.universityname=universityname      assert.universityname=contains         expected.universityname=University
      ...     col.country=country                    assert.country=should be               expected.country=united kingdom      

Verify result data table without thead table
      commonkeywords.Verify Result of data table
      ...     locator_thead=//*[@id="customers"]/tbody/tr[1]   locator_tbody=//*[@id="customers"]/tbody     rowdata=2   ignorcase=true
      ...     col.company=company      assert.company=should be       expected.company=Google  
      ...     col.contact=contact      assert.contact=contains        expected.contact=Maria  

Verify result data table with interaction table
    [Arguments]    ${name}    ${position}    ${office}    ${age}
      commonkeywords.Verify Result of data table
      ...     locator_thead=//*[@id="example"]/thead   locator_tbody=//*[@id="example"]/tbody     rowdata=1   ignorcase=true
      ...     col.name=name               assert.name=contains               expected.name=${name}
      ...     col.position=position       assert.position=should be          expected.position=${position}      
      ...     col.office=office           assert.office=should be            expected.office=${office} 
      ...     col.age=age                 assert.age=should be               expected.age=${age}          

Request Service No Authentication
    main-services.Create Headers Authen Service
    main-services.Create Session Service      servicename=loginws     baseurl=${url_apitest}        &{GLOBAL_APIAUTH_HEADERS}
    ${bodydata}=    Catenate    {"username": "${userapi.username}", "password": "${userapi.password}"}
    Request Service Method    servicename=loginws    method=POST    urlpath=${url_apitest}     requestbody=${bodydata}
    Log    \ntoken:${RESPONSE_JSON}[token]

Request No Basic Authen for method GET
    main-services.Create Session Service      servicename=service_noauth     baseurl=${url_noauth}        &{GLOBAL_APIAUTH_HEADERS}
    Request Service Method    servicename=loginws    method=GET    urlpath=${url_noauth}     requestbody=${EMPTY}
    Log   \nFirstname:${RESPONSE_JSON}[firstname]
    ${checkindata}=     Set Variable       ${RESPONSE_JSON}[bookingdates]
    Log   \nCheckin:${checkindata}[checkin] \nCheckout:${checkindata}[checkout]  

Request Basic Authentication
    main-services.Create Headers Authen Service
    main-services.Create Session Service    servicename=service_basicauth     baseurl=${url_basicauth}       authen=basic_auth     authusername=${userbasicauth.username}    authpassword=${userbasicauth.password}    &{GLOBAL_APIAUTH_HEADERS}
    Request Service Method    servicename=service_basicauth    method=GET     urlpath=${url_basicauth}       requestbody=${EMPTY}
    Log   \Status Authen:${RESPONSE_JSON}[authenticated]

Request Basic Authen in authenticationtest Site
      main-services.Create Headers Authen Service
      main-services.Create Session Service    servicename=service_basicauthsite     baseurl=${url_authtest}       authen=basic_auth     authusername=user   authpassword=pass    &{GLOBAL_APIAUTH_HEADERS}
      Request Service Method    servicename=service_basicauthsite    method=GET     urlpath=${url_authtest}       requestbody=${EMPTY}