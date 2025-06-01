*** Settings ***
Resource          ../../resources/commonkeywords.resource

*** Test Cases ***
Handle datepicker field
    Using choose calendar type

*** Keywords ***
Using choose calendar type
      Set Test Variable    ${locator_inputdate}    //*[@id="id_0"]/input
      Set Test Variable    ${datepick}    ${EMPTY}
      commonkeywords.Open Browser and Go to website    https://preview.colorlib.com/theme/bootstrap/calendar-09/
      commonkeywords.Click button on list page        ${locator_inputdate}
      Wait For Elements State                          //*[contains(@class, 'datetimepicker')]       visible
      commonkeywords.Click button on list page        //*[@title="Select Month"]
      commonkeywords.Click button on list page        //*[@title="Select Year"]
      commonkeywords.Click button on list page        //span[text()='2025']
      commonkeywords.Click button on list page        //span[text()='Apr']
      commonkeywords.Click button on list page        //td[text()='30' and not(contains(@class, 'day new')) and not(contains(@class, 'day old')) ]
      commonkeywords.Verify data form                 ${locator_inputdate}    contains    04/30/2025
      ${datepick}=      Get Text    ${locator_inputdate}
      Log To Console    \n${datepick}

      Set Test Variable    ${locator_inputdate}    //input[@name="date" and @placeholder="Pick a date"]
      commonkeywords.Open Browser and Go to website    https://fengyuanchen.github.io/datepicker/
      commonkeywords.Click button on list page        ${locator_inputdate}
      Wait For Elements State       //*[@class="datepicker-panel"]      visible
      commonkeywords.Click button on list page        //*[@data-view="month current"]
      commonkeywords.Click button on list page        //*[@data-view="year current"]
      commonkeywords.Click button on list page        //*[text()='2025' and not(contains(@data-view, "current"))]
      commonkeywords.Click button on list page        //*[text()='Apr']
      commonkeywords.Click button on list page        //*[text()='1' and contains(@data-view, 'day') and not(contains(@class, "muted"))]
      commonkeywords.Verify data form                 ${locator_inputdate}    contains    04/01/2025
      ${datepick}=      Get Text      ${locator_inputdate}
      Log To Console    ${datepick}
      