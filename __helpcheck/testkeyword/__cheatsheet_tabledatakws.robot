*** Settings ***
Resource          ../../resources/commonkeywords.resource


*** Test Cases ***
Test Verify result data table
    [Documentation]    Handle data table multiple cases
    Open Browser and Go to Web Site Test    https://letcode.in/advancedtable
    Verify result data table with thead table
    commonkeywords.Release user lock and close all browser

    Open Browser and Go to Web Site Test    https://www.techlistic.com/p/demo-selenium-practice.html
    Verify result data table without thead table
    commonkeywords.Release user lock and close all browser

    Open Browser and Go to Web Site Test    https://datatables.net/examples/styling/stripe.html
    commonkeywords.Fill in search field     //*[@id="dt-search-0"]    Gavin Cortez
    Sleep    750ms
    Verify result data table with interaction table    Gavin Cortez    Team Leader    	San Francisco    22

Test Verify Result of Card Data
    Verify Card Data Test

*** Keywords ***
Open Browser and Go to Web Site Test
    [Arguments]    ${url}
      commonkeywords.Open Browser and Go to website          ${url}

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

Verify Card Data Test
    Open Browser and Go to Web Site Test    https://10.6.208.81:1443/usermanagement/auth/login
    commonkeywords.Login System             admin    Netbay@123
    commonkeywords.Go to SUBMENU name       //*[contains(text(),'Configuration')]         //*[contains(text(),'User Management')]
    commonkeywords.Verify Result of Data Card
    ...    cardtitle=umnl-name
    ...    card_index=all
    ...    ignorcase=true
    ...    assertion=contains
    ...    expectedresult=admin