*** Settings ***
Resource          ../../resources/commonkeywords.resource

*** Test Cases ***
Handle datepicker field
    Using choose calendar type

*** Keywords ***
Using choose calendar type
#       commonkeywords.Initialize System and Go to Login Page
#       datasources.Import DataSource USER LOGIN
#       commonkeywords.Login System                   ${DS_LOGIN['superadmin'][${login_col.username}]}      ${DS_LOGIN['superadmin'][${login_col.password}]}
#       commonkeywords.Go to MENU name                ${regishrefmenu}
#       commonkeywords.Click Expand Search Criteria
#       commonkeywords.Click button on list page       ${locator_appvdate_from}
#       Wait For Elements State         //button[@class='current ng-star-inserted']       visible         timeout=20s
#       commonkeywords.Click button on list page        //button[@class='current']
#       commonkeywords.Click button on list page        //span[contains(text(), '2021')]
#       commonkeywords.Click button on list page        //span[contains(text(),'February')]
#       commonkeywords.Click button on list page        //span[@bsdatepickerdaydecorator and (text()='2') and not(contains(@class, 'is-other-month'))]
#
#       ${value}=     Get Text      ${locator_appvdate_from}
#       Log To Console    \n${value}
#       commonkeywords.Verify data form    ${locator_appvdate_from}    should be    2021-02-02
      Set Test Variable    ${locator_inputdate}    //*[@id="id_0"]/input
      Set Test Variable    ${datepick}    ${EMPTY}
      commonkeywords.Open Browser and Go to website    https://preview.colorlib.com/theme/bootstrap/calendar-09/
      commonkeywords.Click button on list page        ${locator_inputdate}
      commonkeywords.Wait Loading state               //*[contains(@class, 'datetimepicker')]       visible
      commonkeywords.Click button on list page        //*[@title="Select Month"]
      commonkeywords.Click button on list page        //*[@title="Select Year"]
      commonkeywords.Click button on list page        //span[text()='2022']
      commonkeywords.Click button on list page        //span[text()='Apr']
      commonkeywords.Click button on list page        //td[text()='30' and not(contains(@class, 'day new')) and not(contains(@class, 'day old')) ]
      commonkeywords.Verify data form                 ${locator_inputdate}    contains    04/30/2022
      ${datepick}=      Get Text    ${locator_inputdate}
      Log To Console    \n${datepick}

      Set Test Variable    ${locator_inputdate}    //*[@id="datepicker"]
      commonkeywords.Open Browser and Go to website    https://demos.telerik.com/kendo-ui/datepicker/index
      commonkeywords.Wait Loading state               //button[@aria-controls="datepicker_dateview"]       visible
      commonkeywords.Click button on list page        //button[@aria-controls="datepicker_dateview"]
      commonkeywords.Wait Loading state               //*[@id="datepicker_dateview" and @aria-hidden="false"]      visible
      commonkeywords.Click button on list page        //a[@data-action="nav-up"]
      commonkeywords.Click button on list page        //a[@data-action="nav-up"]
      commonkeywords.Click button on list page        //a[text()='2020']
      commonkeywords.Click button on list page        //a[text()='Mar']
      commonkeywords.Click button on list page        //a[text()='1' and (contains(@title, 'March'))]
      commonkeywords.Verify data form                 ${locator_inputdate}   contains    3/1/2020
      ${datepick}=      Get Text    ${locator_inputdate}
      Log To Console    ${datepick}

      Set Test Variable    ${locator_inputdate}    //input[@name="date" and @placeholder="Pick a date"]
      commonkeywords.Open Browser and Go to website    https://fengyuanchen.github.io/datepicker/
      commonkeywords.Click button on list page        ${locator_inputdate}
      commonkeywords.Wait Loading state               //*[@class="datepicker-panel"]      visible
      commonkeywords.Click button on list page        //*[@data-view="month current"]
      commonkeywords.Click button on list page        //*[@data-view="year current"]
      commonkeywords.Click button on list page        //*[text()='2022' and not(contains(@data-view, "current"))]
      commonkeywords.Click button on list page        //*[text()='Apr']
      commonkeywords.Click button on list page        //*[text()='1' and contains(@data-view, 'day') and not(contains(@class, "muted"))]
      commonkeywords.Verify data form                 ${locator_inputdate}    contains    04/01/2022
      ${datepick}=      Get Text      ${locator_inputdate}
      Log To Console    ${datepick}
