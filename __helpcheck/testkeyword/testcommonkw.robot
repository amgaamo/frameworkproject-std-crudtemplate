*** Settings ***
Resource          ../../resources/commonkeywords.resource    

*** Test Cases ***
Test Using Keywords
#     Using Keyword for Open New Tab or New Windows
#     Using Keyword for various type of field
#     Using Keyword for Handle Javascript Alert
#     Using keywords Handle for table
#     Using keywords upload and Download
#     Using Keyword form data test
#     commonkeywords.Get Data Current Date

# Handle Convert Number
#       handle convert data test   12500      0
#       handle convert data test   1789.50    2
#       handle convert data test   97800      3


Handle Ant design
    Ant design keyword

*** Keywords ***     
Using Keyword for Open New Tab or New Windows
      commonkeywords.Open Browser and Go to website    https://www.letskodeit.com/practice
      #----------- Get Main pageids ---------------#
      commonkeywords.Get MAIN pageids for switch page
      commonkeywords.Click button on list page    //*[@id="openwindow"]
      Sleep   2s

      #----------- Get New pageids ---------------#
      commonkeywords.Get Information new Page Open
      Set Test Variable    ${NEWPAGE_ALLCOURSES}    ${GLOBAL_NEWPAGE}

      #----- Switch to new page -------#
      commonkeywords.Switch another open page     ${NEWPAGE_ALLCOURSES}
      commonkeywords.Fill in search field         //input[@id="search"]   testNG
      commonkeywords.Click button on list page    //*[@id="search"]/div/button
      commonkeywords.Verify data form    //*[@id="course-list"]/div/div/a/div[2]/h4   contains    testNG    ignorcase=True

      #----- Switch to main page -------#
      commonkeywords.Switch another open page     ${GLOBAL_MAINPAGE}
      commonkeywords.Verify data form    //*[@id="page"]/div[2]/div[2]/div/div/div/div/h1    contains   Practice Page

      commonkeywords.Click button on detail page    //a[@href="https://twitter.com/letskodeit"]
      Sleep    1s
      commonkeywords.Get Information new Page Open
      Set Test Variable    ${NEWPAGE_TWITTER}     ${GLOBAL_NEWPAGE}

      commonkeywords.Switch another open page     ${NEWPAGE_TWITTER}
      Get Url    should be    https://twitter.com/letskodeit

      commonkeywords.Switch another open page     ${GLOBAL_MAINPAGE}
      commonkeywords.Click button on list page    //*[@id="hide-textbox"]
      commonkeywords.Verify Field State    //*[@id="displayed-text"]    hidden

      commonkeywords.Switch another open page     ${NEWPAGE_TWITTER}
      commonkeywords.Verify Field State   //*[contains(text(), 'Joined November')]    visible

      commonkeywords.Switch another open page     ${NEWPAGE_ALLCOURSES}
      commonkeywords.Fill in search field         //input[@id="search"]   python 3.x
      commonkeywords.Click button on list page    //*[@id="search"]/div/button
      Sleep  1s
      commonkeywords.Verify data form    //*[@id="course-list"]/div/div/a/div[2]/h4   contains    python 3.x    ignorcase=True
      
      #----- Open New Browser 2 (open 3 pages) and Switch to new page -------#
      commonkeywords.Open Browser and Go to website    https://authenticationtest.com/
      commonkeywords.Get Information new Page Open
      Set Test Variable    ${NEWPAGE_AUTHTEST}     ${GLOBAL_NEWPAGE}   
      commonkeywords.Switch Another Open Page      ${NEWPAGE_AUTHTEST} 
      commonkeywords.Click button on list page     //a[text()='New Window Challenge']
      commonkeywords.Click button on list page     //button[text()='Log In']
      commonkeywords.Get Information new Page Open
      Set Test Variable    ${NEWPAGE_AUTHTEST_LOGIN}     ${GLOBAL_NEWPAGE}  
      Switch Another Open Page    ${NEWPAGE_AUTHTEST_LOGIN} 
      commonkeywords.Fill in data form    //*[@id="email"]      newwindow@authenticationtest.com
      commonkeywords.Fill in data form    //*[@id="password"]   pa$$w0rd
      commonkeywords.Click button on detail page    //*[@value="Log In"]
      commonkeywords.Verify Field State    //*[text()="You're logged in!"]    visible
      commonkeywords.Switch another open page     ${NEWPAGE_AUTHTEST}
      commonkeywords.Click button on list page     //button[text()='Log In']
      commonkeywords.Get Information new Page Open
      
      Set Test Variable    ${NEWPAGE_AUTHTEST_LOGIN2}     ${GLOBAL_NEWPAGE} 
      Switch Another Open Page    ${NEWPAGE_AUTHTEST_LOGIN2} 
      Get Url    contains    newWindowChallenge
      commonkeywords.Fill in data form    //*[@id="email"]      newwindow@authenticationtest.com

      #----- Switch to main page -------#
      commonkeywords.Switch another open page     ${GLOBAL_MAINPAGE}
      commonkeywords.Verify data form    //*[@id="page"]/div[2]/div[2]/div/div/div/div/h1    contains   Practice Page

       #----- Open New Browser 3 (open 4 pages) and Switch to new page -------#
      commonkeywords.Open Browser and Go to website    https://letcode.in/windows
      commonkeywords.Get Information new Page Open     

      Set Test Variable    ${NEWPAGE_LETCODE}     ${GLOBAL_NEWPAGE}   
      commonkeywords.Switch Another Open Page     ${NEWPAGE_LETCODE} 
      commonkeywords.Click button on list page    //*[@id="home"]
      commonkeywords.Get Information new Page Open     
      
      Set Test Variable    ${NEWPAGE_LETCODE_HOME}      ${GLOBAL_NEWPAGE}  
      commonkeywords.Switch Another Open Page    ${NEWPAGE_LETCODE_HOME} 
      commonkeywords.Click button on list page    //*[text()='Tabs'] 
      commonkeywords.Click button on list page    //a[@href="https://www.facebook.com/ortoni/"]
      Sleep    2s
      commonkeywords.Get Information new Page Open 

      Set Test Variable    ${NEWPAGE_LETCODE_FB}      ${GLOBAL_NEWPAGE}  
      commonkeywords.Switch Another Open Page    ${NEWPAGE_LETCODE_FB} 
      Get Url    contains    facebook
      
      commonkeywords.Switch Another Open Page    ${NEWPAGE_LETCODE_HOME} 
      commonkeywords.Click button on list page    //a[@href="https://www.instagram.com/ortonikc/"]
      Sleep    2s
      commonkeywords.Get Information new Page Open       
      Set Test Variable    ${NEWPAGE_LETCODE_IG}      ${GLOBAL_NEWPAGE}  
      commonkeywords.Switch Another Open Page    ${NEWPAGE_LETCODE_IG} 
      Get Url    contains    ortonikc

      commonkeywords.Switch another open page     ${GLOBAL_MAINPAGE}
      commonkeywords.Verify data form    //*[@id="page"]/div[2]/div[2]/div/div/div/div/h1    contains   Practice Page
    
      commonkeywords.Release user lock and close all browser

Using Keyword for various type of field
      commonkeywords.Open Browser and Go to website    https://courses.letskodeit.com/practice
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
      commonkeywords.Fill in data form    //*[@id="carselect"]      honda        sel_attr=value
      commonkeywords.Verify data form     //*[@id="carselect"]      should be    honda   sel_attr=value
      Log To Console    ${GLOBAL_RETURNDATA_VALUE}

Using Keyword for Handle Javascript Alert
      commonkeywords.Fill in data form    //*[@id="name" and @name="enter-name"]            Test Robot
      commonkeywords.Click Button and Handle confirmation alert    //*[@id="alertbtn"]      OK

      commonkeywords.Fill in data form    //*[@id="name" and @name="enter-name"]            Robot
      commonkeywords.Click Button and Get message alert dialog     //*[@id="alertbtn"]
      Should Contain    ${GLOBAL_ALERTMSG}      Robot

      commonkeywords.Fill in data form    //*[@id="name" and @name="enter-name"]              My Robot
      commonkeywords.Click button and Handle confirmation alert    //*[@id="confirmbtn"]      Cancel

      commonkeywords.Fill in data form    //*[@id="name" and @name="enter-name"]              Robot101
      commonkeywords.Click Button and Verify message alert dialog    //*[@id="confirmbtn"]    Hello Robot101, Are you sure you want to confirm?
      commonkeywords.Release user lock and close all browser

Using keywords Handle for table
      #### Using for Handle table ####
      Open Browser and Go to website    https://letcode.in/advancedtable
      commonkeywords.Verify Result of data table
      ...     locator_thead=//*[@id="advancedtable"]/thead    locator_tbody=//*[@id="advancedtable"]/tbody  rowdata=all   ignorcase=true
      ...     col.universityname=universityname      assert.universityname=contains         expected.universityname=university
      ...     col.country=country                    assert.country=should be               expected.country=united kingdom
      commonkeywords.Release user lock and close all browser

Using keywords upload and Download
      commonkeywords.Open Browser and Go to website      https://demo.guru99.com/test/upload/
      commonkeywords.Choose file to upload    //*[@id="uploadfile_0"]     ${CURDIR}${/}_testupload.txt
      commonkeywords.Click Upload Button      //*[@id="submitbutton"]
      commonkeywords.Verify Button State      //button[@name="send" and contains(@class, 'active')]    hidden
      commonkeywords.Verify data form         //*[@id="res"]    contains    successfully

      commonkeywords.Open Browser and Go to website      https://eternallybored.org/misc/wget/
      commonkeywords.Download data and save file to download folder     //*[@id="content"]/table/tbody/tr[5]/td[4]/a
      commonkeywords.Clear Directory download file    ${GLOBAL_PATHDIR}
      commonkeywords.Release user lock and close all browser

Using Keyword form data test
      commonkeywords.Open Browser and Go to website      https://letcode.in/forms
    
      commonkeywords.Fill out data in form
      ...     firstname     lastname     email    phonenumber    country    gender     agreeterm
      ...     locator.firstname=//*[@id="firstname"]                                                value.firstname=Robotname                  selattr.firstname=${EMPTY}
      ...     locator.lastname=//*[@id="lasttname"]                                                 value.lastname=Autolastname                selattr.lastname=${EMPTY}
      ...     locator.email=//*[@id="email"]                                                        value.email=robot@bot.com                  selattr.email=${EMPTY}
      ...     locator.phonenumber=//*[@id="Phno"]                                                   value.phonenumber=029999999                selattr.phonenumber=${EMPTY}   
      ...     locator.country=//*[@class="card-content"]/form/div[5]/div[2]/div/div/div/select      value.country=Azerbaijan                   selattr.country=value      
      ...     locator.gender=//*[@id="male"]                                                        value.gender=Check                         selattr.gender=${EMPTY}  
      ...     locator.agreeterm=//*[@class="card-content"]/form/div[7]/div/label/input              value.agreeterm=check                      selattr.agreeterm=${EMPTY}  

      commonkeywords.Verify data form is correct
      ...     firstname     lastname     email    phonenumber    country    gender     agreeterm
      ...     locator.firstname=//*[@id="firstname"]                                                assert.firstname=should be        expected.firstname=Robotname          selattr.firstname=${EMPTY}
      ...     locator.lastname=//*[@id="lasttname"]                                                 assert.lastname=should be         expected.lastname=Autolastname        selattr.lastname=${EMPTY}
      ...     locator.email=//*[@id="email"]                                                        assert.email=should be            expected.email=robot@bot.com          selattr.email=${EMPTY}
      ...     locator.phonenumber=//*[@id="Phno"]                                                   assert.phonenumber=should be      expected.phonenumber=029999999        selattr.phonenumber=${EMPTY}   
      ...     locator.country=//*[@class="card-content"]/form/div[5]/div[2]/div/div/div/select      assert.country=should be          expected.country=Azerbaijan           selattr.country=value      
      ...     locator.gender=//*[@id="male"]                                                        assert.gender=should be           expected.gender=Check                 selattr.gender=${EMPTY}  
      ...     locator.agreeterm=//*[@class="card-content"]/form/div[7]/div/label/input              assert.agreeterm=should be        expected.agreeterm=check              selattr.agreeterm=${EMPTY}  

      commonkeywords.Release user lock and close all browser

handle convert data test
    [Arguments]    ${number}    ${point}
        ${formatnumber}=    commonkeywords.Convert number to decimal format    ${number}    ${point}
        Log To Console     \n${formatnumber}

Ant design keyword
      # Open Browser and Go to website   https://ng.ant.design/components/select/en
      # Fill in data form    //*[@id="components-select-demo-search"]/section[1]/div/nz-demo-select-search/nz-select/nz-select-top-control/nz-select-search/input    Jack    is_antdesign=true

      Open Browser and Go to website   https://ng.ant.design/components/select/en
      Fill in data form   //*[@id="components-select-demo-basic"]/section[1]/div/nz-demo-select-basic/nz-select[1]   Jack    is_antdesign=true