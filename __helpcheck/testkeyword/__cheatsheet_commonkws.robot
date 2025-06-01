*** Settings ***
Resource          ../../resources/commonkeywords.resource
Resource          ../../resources/utilitykeywords.resource

*** Test Cases ***
Handle Open New Tab or New Windows
    [Documentation]   การจัดการเปิดแท็บใหม่หรือหน้าต่างใหม่สำหรับการทดสอบ
    Using Keyword for Open New Tab or New Windows

Test Keyword Fill in and Verify various type of field
    [Documentation]   การกรอกข้อมูลในฟอร์มและการตรวจสอบข้อมูลที่กรอก
    Open Browser and Go to Web Site Test    https://www.letskodeit.com/practice
    Using Keyword Fill in data form and Verify data form for various type of field

Test Fill All Data and Verify
    [Documentation]   การกรอกข้อมูลในฟอร์มและการตรวจสอบข้อมูลที่กรอก
    Open Browser and Go to Web Site Test    https://letcode.in/forms
    Fill in all data in form
    Verify all data in form

Handle Javascript Alert
    [Documentation]   การจัดการกับ Javascript Alert
    Open Browser and Go to Web Site Test    https://letcode.in/alert
    Using Keyword for Handle Javascript Alert

Handle Convert Number
      handle convert data test   12500         0
      Should Be True      '${GLOBAL_FORMATTED_NUMBER}' == '12,500'
      handle convert data test   1789.5       2
      Should Be True      '${GLOBAL_FORMATTED_NUMBER}' == '1,789.50'
      handle convert data test   97800.11      3    use_comma=False
      Should Be True      '${GLOBAL_FORMATTED_NUMBER}' == '97800.110'

Test Upload and Download file
    [Documentation]   การทดสอบการอัพโหลดและดาวน์โหลดไฟล์
    Handle keyword for Upload file test
    Handle keyword for Download file test
    Handle keyword for Download file test    ${EXECDIR}${/}resources${/}_download_file

Test Ant Design Keyword
    [Documentation]   การทดสอบการใช้งาน Ant Design Keyword
    Ant design keyword for select field type
    Ant design keyword for select field choose multiple value
    Ant design keyword for upload file test

Test Handle YAML Data
    Load YAML Data    ${YAMLPATH_USER_MANAGEMENT}
    Log Many    ${YAML_DATA}[allfields]

*** Keywords ***
Open Browser and Go to Web Site Test
    [Arguments]    ${url}
      commonkeywords.Open Browser and Go to website          ${url}

Using Keyword for Open New Tab or New Windows
    [Documentation]   การจัดการเปิดแท็บใหม่หรือหน้าต่างใหม่สำหรับการทดสอบ 
    ...               การจัดการจะต้องใช้คำสั่ง Switch Page เพื่อสลับไปยังหน้าต่างใหม่ที่เปิดขึ้นมา 
    ...               โดยใช้คำสั่ง Get MAIN pageids เพื่อเก็บค่า pageids ของหน้าหลักก่อนที่จะเปิดหน้าต่างใหม่
     
      commonkeywords.Open Browser and Go to website    https://www.letskodeit.com/practice
      #----------- Get Main pageids ---------------#
      commonkeywords.Get MAIN pageids for switch page
      Set Test Variable     ${MAINPAGE_TEST}       ${GLOBAL_MAINPAGE}    
      commonkeywords.Click button on list page    //*[@id="openwindow"]

      #----------- Get New pageids Page1 ---------------#
      commonkeywords.Get Information new Page Open
      Set Test Variable    ${NEWPAGE_1_ALLCOURSES}    ${GLOBAL_NEWPAGE}

      #----- Switch to new page 1 -------#
      commonkeywords.Switch another open page     ${NEWPAGE_1_ALLCOURSES}
      commonkeywords.Fill in search field         //input[@id="search"]   testNG
      commonkeywords.Click button on list page    //*[@id="search"]/div/button
      commonkeywords.Verify data form             //*[@id="course-list"]/div/div/a/div[2]/h4   contains    testNG    ignorcase=True

      #----- Switch to main page -------#
      commonkeywords.Switch another open page     ${MAINPAGE_TEST}
      commonkeywords.Verify data form    //*[@id="page"]/div[2]/div[2]/div/div/div/div/h1    contains   Practice Page
      commonkeywords.Click button on list page    //*[@id="opentab"]

     #----------- Get New pageids Page2 ---------------#
      commonkeywords.Get Information new Page Open
      Set Test Variable    ${NEWTAB_2_ALLCOURSES}    ${GLOBAL_NEWPAGE}     

      #----- Switch to new tab Page 2 -------#
      commonkeywords.Switch another open page     ${NEWTAB_2_ALLCOURSES}
      commonkeywords.Fill in search field         //input[@id="search"]   Rest API
      commonkeywords.Click button on list page    //*[@id="search"]/div/button
      commonkeywords.Verify data form             //*[@id="course-list"]/div/div/a/div[2]/h4   contains    Rest API    ignorcase=True

      #----- Switch to page 1 -------#
     commonkeywords.Switch another open page     ${NEWPAGE_1_ALLCOURSES}
     commonkeywords.Click button on list page    //*[text()="Sign In"]
     commonkeywords.Verify Button State          //*[@id="login"]    visible

     #----- Back to main page -------#
    commonkeywords.Switch another open page     ${MAINPAGE_TEST}
    commonkeywords.Verify data form    //*[@id="page"]/div[2]/div[2]/div/div/div/div/h1    contains   Practice Page
    Close Browser

Using Keyword Fill in data form and Verify data form for various type of field
    [Documentation]   การใช้งาน Keyword สำหรับกรอกข้อมูลรูปแบบต่างๆ ในฟอร์มและการตรวจสอบข้อมูลที่กรอก
      
      #----- For Radio Type -------#
      commonkeywords.Fill in data form    //*[@id="benzradio"]     ${EMPTY}
      commonkeywords.Verify data form     //*[@id="benzradio"]     should be    True
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}

      commonkeywords.Fill in data form    //*[@id="hondaradio"]    ${EMPTY}
      commonkeywords.Verify data form     //*[@id="hondaradio"]    should be    True
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}
      commonkeywords.Verify data form     //*[@id="benzradio"]     should be    unchecked
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}

      #----- For Checkbox Type -------#
      commonkeywords.Fill in data form    //*[@id="benzcheck"]    True
      commonkeywords.Verify data form     //*[@id="benzcheck"]    should be    True
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}
      commonkeywords.Fill in data form    //*[@id="bmwcheck"]     True
      commonkeywords.Verify data form     //*[@id="bmwcheck"]     should be    True
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}

      #----- For Select Type (Dropdown list) -------#
      commonkeywords.Fill in data form    //*[@id="carselect"]      BMW
      commonkeywords.Verify data form     //*[@id="carselect"]      should be    BMW
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}
      commonkeywords.Fill in data form    //*[@id="carselect"]      benz         sel_attr=value
      commonkeywords.Verify data form     //*[@id="carselect"]      should be    Benz
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}
      commonkeywords.Fill in data form    //*[@id="carselect"]      Honda        sel_attr=label
      commonkeywords.Verify data form     //*[@id="carselect"]      should be    Honda   sel_attr=label
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}

Fill in all data in form
    [Documentation]    Fill out mass field data form with various fields
    &{firstname}=      utilitykeywords.Create Field Dictionary for field sets    locator_field=//*[@id="firstname"]                                                   value=Suphanaya    
    &{lastname}=       utilitykeywords.Create Field Dictionary for field sets    locator_field=//*[@id="lasttname"]                                                   value=Nadeena                 
    &{email}=          utilitykeywords.Create Field Dictionary for field sets    locator_field=//*[@id="email"]                                                       value=testchanchai@mail.com             
    &{countrycode}=    utilitykeywords.Create Field Dictionary for field sets    locator_field=//div[@class="card-content"]/form/div[2]/div[2]/div/div/div/select     value=66                        select_attr=value
    &{country}=        utilitykeywords.Create Field Dictionary for field sets    locator_field=//div[@class="card-content"]/form/div[5]/div[2]/div/div/div/select     value=Aruba                     select_attr=label
    &{gender}=         utilitykeywords.Create Field Dictionary for field sets    locator_field=//*[@id="male"]                                                        value=True  
    &{agreement}=      utilitykeywords.Create Field Dictionary for field sets    locator_field=//label[@class="checkbox"]/input                                       value=check                     is_checkboxtype=True   
    
    Log Many    \n&{firstname}    \n&{lastname}    \n&{email}    \n&{countrycode}    \n&{country}

    @{field_sets}=    Create List    
    ...                   ${firstname}    ${lastname}    ${email}    ${countrycode}    
    ...                   ${country}      ${gender}      ${agreement}
    
    commonkeywords.Fill In All Fields In Form    @{field_sets} 

Verify all data in form
    [Documentation]    Verify that the mass field data form is filled correctly
    &{firstname}=      utilitykeywords.Create Field Dictionary for field sets    locator_field=//*[@id="firstname"]                                                   locator_view=//*[@id="firstname"]                                                         value=Suphanaya    
    &{lastname}=       utilitykeywords.Create Field Dictionary for field sets    locator_field=//*[@id="lasttname"]                                                   locator_view=//*[@id="lasttname"]                                                         value=Nadeena                 
    &{email}=          utilitykeywords.Create Field Dictionary for field sets    locator_field=//*[@id="email"]                                                       locator_view=//*[@id="email"]                                                             value=testchanchai@mail.com             
    &{countrycode}=    utilitykeywords.Create Field Dictionary for field sets    locator_field=//div[@class="card-content"]/form/div[2]/div[2]/div/div/div/select     locator_view=//div[@class="card-content"]/form/div[2]/div[2]/div/div/div/select           value=66                        select_attr=value
    &{country}=        utilitykeywords.Create Field Dictionary for field sets    locator_field=//div[@class="card-content"]/form/div[5]/div[2]/div/div/div/select     locator_view=//div[@class="card-content"]/form/div[5]/div[2]/div/div/div/select           value=Aruba                     select_attr=label
    &{gender}=         utilitykeywords.Create Field Dictionary for field sets    locator_field=//*[@id="male"]                                                        locator_view=//*[@id="male"]                                                              value=True                      assert=should be
    &{agreement}=      utilitykeywords.Create Field Dictionary for field sets    locator_field=//label[@class="checkbox"]/input                                       locator_view=//label[@class="checkbox"]/input                                             value=check                     is_checkboxtype=True   
    
    Log Many    \n&{firstname}    \n&{lastname}    \n&{email}    \n&{countrycode}    \n&{country}    \n${gender}    \n&{agreement}

    @{field_sets}=    Create List    
    ...                   ${firstname}    ${lastname}    ${email}    ${countrycode}    
    ...                   ${country}      ${gender}      ${agreement}
    
    commonkeywords.Validate All Fields In Form    @{field_sets} 

Using Keyword for Handle Javascript Alert
      commonkeywords.Click Button and Get message alert dialog     //*[@id="accept"]
      Log    ${GLOBAL_ALERTMSG}   console=True
      Should Contain    ${GLOBAL_ALERTMSG}      LetCode

      commonkeywords.Click Button and Prompt input alert dialog    //*[@id="prompt"]     Test Input Data in prompt
            
      commonkeywords.Click Button and Handle confirmation alert    //*[@id="confirm"]     OK

Handle convert data test
    [Documentation]    Handle convert number to decimal format 1000 to 1,000.00
    [Arguments]    ${number}    ${point}    ${use_comma}=True
        ${formatnumber}=    commonkeywords.Convert number to decimal format    ${number}    ${point}    ${use_comma}
        Log To Console     \n${GLOBAL_FORMATTED_NUMBER}

Handle keyword for Upload file test
    [Documentation]   การทดสอบการอัพโหลดและดาวน์โหลดไฟล์
    Open Browser and Go to Web Site Test        https://practice.expandtesting.com/upload/
    commonkeywords.Fill in data form            //*[@id="fileInput"]       ${CURDIR}${/}_testupload.txt
    commonkeywords.Click button on list page    //*[@id="fileSubmit"]
    commonkeywords.Verify data form             //*[@id="uploaded-files"]   contains    testupload.txt
    commonkeywords.Release user lock and close all browser

Handle keyword for Download file test
    [Documentation]   การทดสอบการดาวน์โหลดไฟล์
    [Arguments]    ${pathfolder_download}=${EXECDIR}${/}testsuite${/}_download_file
    Open Browser and Go to Web Site Test        https://practice.expandtesting.com/download
    commonkeywords.Download data and save file to download folder     //a[@data-testid="cdct.jpg"]    folder_download=${pathfolder_download}
    commonkeywords.Clear Directory download file    ${GLOBAL_PATHDIR}
    commonkeywords.Release user lock and close all browser

Ant design keyword for select field type
      Open Browser and Go to website   https://ng.ant.design/components/select/en

      # autocomplete select field
      Fill in data form    //*[@id="components-select-demo-search"]/section[1]/div/nz-demo-select-search/nz-select/nz-select-top-control/nz-select-search/input    Jack    is_antdesign=true
      
      #select field dropdown list
      Fill in data form    //*[@id="components-select-demo-basic"]/section[1]/div/nz-demo-select-basic/nz-select[1]   Jack    is_antdesign=true   

Ant design keyword for select field choose multiple value
      Open Browser and Go to website   https://ng.ant.design/components/select/en     
      Fill in data form   //*[@id="components-select-demo-multiple"]/section[1]/div/nz-demo-select-multiple/nz-select/nz-select-top-control/nz-select-search/input   g16    is_antdesign=true   
      Fill in data form   //*[@id="components-select-demo-multiple"]/section[1]/div/nz-demo-select-multiple/nz-select/nz-select-top-control/nz-select-search/input   m22    is_antdesign=true   

Ant design keyword for upload file test
      Open Browser and Go to website   https://ng.ant.design/components/upload/en
      Fill in data form    //*[@id="components-upload-demo-drag"]/section[1]/div/nz-demo-upload-drag/nz-upload/div/div/input    ${CURDIR}${/}_testupload.txt  