*** Settings ***
Resource    resourcekeywords.resource

*** Variables ***
##### Default Values #####
${VAR_DEFAULT_PAGING}           10
${VAR_DEFAULT_PASSWORD}         Robot@123
${VAR_DEFAULT_NORECORDFOUND}    No records found

#-----------------------------------------------------------------#

${LOCATOR_TITLE_MODAL}          //*[@id="swal2-title"]
${LOCATOR_CONTENT_MODAL}        //*[@id="swal2-content"]

##### Modal Dialog Button #####
${LOCATOR_MODAL_BTN}            //button[contains(text(),'::buttonname::')] 

#------------------------------------------------------------------#

${LOCATOR_LOADING_BTN}                //button[contains(text(),'Loading')]
${LOCATOR_LOADING}                    //div[contains(@class,"spinner-border")]

${LOCATOR_USERNAME_FIELD}             //*[@id="login-username"]
${LOCATOR_PASSWORD_FIELD}             //*[@id="login-password"]
${LOCATOR_LOGIN_BTN}                  //*[contains(@class, "btn-login")]

${LOCATOR_WELCOME_TITLE}              //*[contains(@class,'user-profile')]
${LOCATOR_HEADER_MENU}                //*[@id="header-menu-btn"]
${LOCATOR_MENULOGOUT}                 //*[contains(text(),'Logout')]

${LOCATOR_ISEXPAND_SUBMENU}           //*[contains(@class,"ng-star-inserted show")]
${LOCATOR_SIDEBAR_TOGGLE}             //*[@id="sidebar-toggle-btn"]
${LOCATOR_SIDEBARPANEL}               //*[contains(@class,"menuleft-open")]

${LOCATOR_CURRENT_PAGENAME}           //*[@aria-current="page"]

${LOCATOR_SEARCH_CRITERIA_VISIBLE}    //*[@class="collapse in show"]
${LOCATOR_SERACH_CRITERIA_BTN}        //button[contains(@class, 'btn-search-box')]

${LOCATOR_NOTIFIER_VISIBLE}           //div[@aria-label="::title_label::"] 
${LOCATOR_NOTIFIER_CONTENT}           //div[@role="alertdialog" and contains(@aria-label, '::content_label::')]
  

&{mainmenu}       configuration=//*[@title="Configuration"]
&{submenu}        usermgt=//a[contains(@title, 'User Management')]
...               companyMgt=//a[contains(@title, 'Company Management')]

&{menuname}       usermgt=User Management
...               companyMgt=Company Management

${homemenu}       //*[contains(@href, '/mainmenu/home') and contains(@class,'brand')]

# Pagination Info.
${LOCATOR_PAGINATION_LINK}     //a[@class="page-link" and contains(text(), '::PAGENUM::')]

#Email Address (Less Secure)
${HOST_IMAP_TEMPEMAIL}          imap.mail.yahoo.com     
${CONF_TEMPEMAIL_USEREMAIL}     robot.qanb@yahoo.com
${CONF_TEMPEMAIL_PASSEMAIL}     evnfpzerwhejxefd


*** Keywords ***
Initialize System and Go to Login Page
      resourcekeywords.Set Data for Run Automated Test
      ${SET_BROWSER}=    Set Variable If  '${_fixdata_}'=='true'     ${VAR_BROWSER}        ${ENV_BROWSER}   

      Run Keyword If   '${SET_BROWSER}'=='chrome'     New Browser     browser=chromium    headless=${_headlessmode_}    channel=chrome
      ...    ELSE IF   '${SET_BROWSER}'=='msedge'     New Browser     browser=chromium    headless=${_headlessmode_}    channel=msedge
      ...    ELSE IF   '${SET_BROWSER}'=='chromium'   New Browser     browser=chromium    headless=${_headlessmode_}
      ...    ELSE IF   '${SET_BROWSER}'=='firefox'    New Browser     browser=firefox     headless=${_headlessmode_}
      ...    ELSE IF   '${SET_BROWSER}'=='safari'     New Browser     browser=webkit      headless=${_headlessmode_}

      New Context           ignoreHTTPSErrors=True    acceptDownloads=True
      New Page

      Run Keyword If    '${_fixdata_}'=='true'
      ...                Go To        ${URLTEST}/${VAR_PATHLOGIN_URL}/          timeout=00:02:00
      ...       ELSE     Go To        ${URLTEST}/${URLPATH}/                    timeout=00:02:00

      Set Viewport Size     ${_SET_DISPLAY_HEIGHT}    ${_SET_DISPLAY_WIDTH}

Open Browser and Go to website
    [Arguments]     ${url}
      Run Keyword If   '${VAR_BROWSER}'=='chrome'     New Browser     browser=chromium    headless=${_headlessmode_}    channel=chrome
      ...    ELSE IF   '${VAR_BROWSER}'=='msedge'     New Browser     browser=chromium    headless=${_headlessmode_}    channel=msedge
      ...    ELSE IF   '${VAR_BROWSER}'=='chromium'   New Browser     browser=chromium    headless=${_headlessmode_}
      ...    ELSE IF   '${VAR_BROWSER}'=='firefox'    New Browser     firefox=firefox     headless=${_headlessmode_}
      ...    ELSE IF   '${VAR_BROWSER}'=='safari'     New Browser     browser=webkit      headless=${_headlessmode_}      

      New Context     ignoreHTTPSErrors=True      acceptDownloads=True
      New Page
      Go To           ${url}       timeout=00:02:00
      Set Viewport Size     ${_SET_DISPLAY_HEIGHT}    ${_SET_DISPLAY_WIDTH}

Extract Value from JSON data
   [Arguments]    ${jsondata}    ${jsonpath}
         ${GLOBAL_JSONVALUE}=       Get Value From Json         ${jsondata}       ${jsonpath}
         Set Global Variable        ${GLOBAL_JSONVALUE}

Convert Data to lower or upper case
    [Arguments]   ${convertto}    ${data}
    IF    '${convertto}'=='lower'
          ${GLOBAL_DATACONVERT}=        Convert To Lower Case       ${data}
    ELSE IF   '${convertto}'=='upper'
          ${GLOBAL_DATACONVERT}=        Convert To Upper Case       ${data}
    ELSE
          Fail   \nPlease check argument convert to should equeal 'lower' or 'upper'
    END  
    Set Global Variable     ${GLOBAL_DATACONVERT}

Convert number to decimal format
    [Arguments]    ${number}    ${point}=2
         ${GLOBAL_FORMATTED_NUMBER}=    Evaluate    "{:,.${point}f}".format(float(${number}))
         Set Global Variable    ${GLOBAL_FORMATTED_NUMBER}

#------------------------- Using for new tab or new windows --------------------------------#
Get MAIN pageids for switch page
    ${idpage}=       Get Page Ids          ALL
    ${GLOBAL_MAINPAGE}=        Set Variable          ${idpage}[0]

    Set Global Variable     ${GLOBAL_MAINPAGE}

Get Information New Page Open
    Sleep   1500ms

    ${ACTIVE_PAGE}=          Get Page Ids       ACTIVE 
    ${activepage_length}=    Get Length         ${ACTIVE_PAGE}

    IF  '${activepage_length}'=='1'
        ${get_pageall}=      Get Page Ids       ALL
        Set Global Variable     ${GLOBAL_NEWPAGE}     ${get_pageall}[0]
    ELSE
        ${get_pageactive}=       Get Page Ids      page=CURRENT   
        ${get_pageall}=          Get Page Ids      page=ALL    
        Log Many    ${get_pageall} 

        ${length_pageactive}=    Get Length        ${get_pageactive} 
        ${length_pageall}=       Get Length        ${get_pageall} 
        ${index_pageactive}=     Set Variable      -2

        FOR   ${index}      IN RANGE      ${length_pageall}
             ${is_newpage}=    Run Keyword And Return Status    Should Be True    '${get_pageactive}[-2]'=='${get_pageall}[${index_pageactive}]'
             IF   '${is_newpage}'=='True'
                 ${index_pageactive}=   Evaluate    ${index_pageactive}+1
                 Set Global Variable     ${GLOBAL_NEWPAGE}      ${get_pageall}[${index_pageactive}]
                 Exit For Loop
             ELSE
                 ${index_pageactive}=   Evaluate    ${index_pageactive}-1
             END
        END  
    END
          
Switch Another Open Page
    [Arguments]      ${idpage}
      Sleep  1500ms
      Switch Page       ${idpage}       context=ALL         browser=ALL

#--------------------- Using for Modal Yes/No/OK/Close Button ----------------------------------#
Click Modal Button
    [Arguments]     ${button_name}

      IF  '${button_name}'=='ใช่'
          ${locator_buttonmodal}=       Set Variable      //button[text()='ใช่']
      ELSE IF  '${button_name}'=='ไม่ใช่'
          ${locator_buttonmodal}=       Set Variable      //button[text()='ไม่ใช่']
      ELSE
          ${locator_buttonmodal}=       Replace String    ${LOCATOR_MODAL_BTN}    ::buttonname::    ${button_name}
      END

      Wait For Elements State       ${locator_buttonmodal}    visible     timeout=50s
      Click     ${locator_buttonmodal}

Verify Modal Title message
      [Arguments]    ${exp_titlemsg}
         Sleep   500ms
         Wait For Elements State      ${LOCATOR_TITLE_MODAL}      visible         timeout=40s
         Get Text    ${LOCATOR_TITLE_MODAL}        contains          ${exp_titlemsg}

Verify Modal Content message
      [Arguments]    ${exp_contentmsg}
         Sleep   500ms
         Wait For Elements State      ${LOCATOR_CONTENT_MODAL}     visible      timeout=40s
         Get Text     ${LOCATOR_CONTENT_MODAL}     contains          ${exp_contentmsg}

Verify Modal should Hidden
         Sleep   500ms
         Wait For Elements State           ${LOCATOR_TITLE_MODAL}        hidden         timeout=30
         Wait For Elements State           ${LOCATOR_CONTENT_MODAL}      hidden         timeout=60

Verify alert notifier
    [Arguments]       ${titlelabel}     ${contentlabel}
      
      ${locator_notifier_title}=        Replace String       ${LOCATOR_NOTIFIER_VISIBLE}    ::title_label::        ${titlelabel} 
      Wait For Elements State           ${locator_notifier_title}       visible       timeout=10

      ${locator_notifier_contenttxt}=   Replace String       ${LOCATOR_NOTIFIER_CONTENT}   ::content_label::      ${contentlabel} 
      Wait For Elements State           ${locator_notifier_contenttxt}       visible       timeout=10
      Wait For Elements State           ${locator_notifier_title}            hidden        timeout=20

#------------------------------- Keywords : Login/Logout System -------------------------------------------------#
Login user system
   [Arguments]   ${userset}     ${username}=${EMPTY}     ${passsword}=${EMPTY}
      resourcekeywords.Get User for login system    ${userset}
      datasources.Import DataSource USER LOGIN
      Run Keyword If    '${userset}'=='masteruser'     Login System    ${username}         ${passsword}
      Run Keyword If    '${userset}'=='user1'          Login System    ${GLOBAL_USER1}     ${GLOBAL_PWD1}
      Run Keyword If    '${userset}'=='user2'          Login System    ${GLOBAL_USER2}     ${GLOBAL_PWD2}
      Run Keyword If    '${userset}'=='user3'          Login System    ${GLOBAL_USER3}     ${GLOBAL_PWD3}
      Run Keyword If    '${userset}'=='user4'          Login System    ${GLOBAL_USER4}     ${GLOBAL_PWD4}
      Run Keyword If    '${userset}'=='user5'          Login System    ${GLOBAL_USER5}     ${GLOBAL_PWD5}

Release user lock and close all browser
   [Arguments]    ${userset}=${EMPTY}
      Run Keyword If    '${_concurrentmode_}'=='true'
      ...                Run Keywords      Release Lock         ${userset}
      ...                AND               Release Value Set
      ...                AND               Close Browser        ALL
      ...       ELSE     Close Browser     ALL

Login System
   [Arguments]    ${username}    ${password}
      Fill in Username Field         ${username}
      Fill in Password Field         ${password}
      Click Login Button
      Ignore warning Login
      Verify Welcome page

Logout System
      Click       ${LOCATOR_HEADER_MENU}
      Click       ${LOCATOR_MENULOGOUT}
      Click Modal Button    Yes

Login Waiting Loading
      Wait For Elements State         ${LOCATOR_LOADING_BTN}       hidden        timeout=30

#+++++++++++ Generate Data Test +++++++++++#
Get Data Current Date
   # -------------------------------------------------------------------------------------------#
   # ${GLOBAL_CURDATE_YMD} >> ex. 2021-11-12        ${GLOBAL_CURDATE_DMY} >> ex. 12/11/2021     #
   # ${GLOBAL_CURDATE_DDMMMYYYY} >> ex.12-NOV-2021  ${GLOBAL_CURDATE_DDMMMYY} >> ex.12-NOV-21   #
   # -------------------------------------------------------------------------------------------# 
   
    ${currdate}=        Get Current Date
    ${GLOBAL_CURDATE_YMD}=          Convert Date        ${currdate}          result_format=%Y-%m-%d
    ${GLOBAL_CURDATE_DMY}=          Convert Date        ${currdate}          result_format=%d/%m/%Y
    ${GLOBAL_CURDATE_DDMMMYYYY}=    Convert Date        ${currdate}          result_format=%d-%b-%Y
    ${GLOBAL_CURDATE_DDMMMYY}=      Convert Date        ${currdate}          result_format=%d-%b-%y

    Set Global Variable     ${GLOBAL_CURDATE_YMD}
    Set Global Variable     ${GLOBAL_CURDATE_DMY}
    Set Global Variable     ${GLOBAL_CURDATE_DDMMMYYYY}
    Set Global Variable     ${GLOBAL_CURDATE_DDMMMYY}

Generate Random Values
    [Arguments]     ${lengthno}     ${lenghtletter}    ${is_upper}=true
      ${GLOBAL_RANDOMNO}=        Generate Random String      ${lengthno}            [NUMBERS]
      
      IF  '${is_upper}' in ['true','True']
          ${GLOBAL_RANDOMLETTER}=    Generate Random String      ${lenghtletter}        [UPPER]
      ELSE IF   '${is_upper}' in ['false','False']
          ${GLOBAL_RANDOMLETTER}=    Generate Random String      ${lenghtletter}        [LOWER]
      ELSE  
          ${GLOBAL_RANDOMLETTER}=    Generate Random String      ${lenghtletter}        [LETTERS]
      END
      Set Global Variable       ${GLOBAL_RANDOMNO}
      Set Global Variable       ${GLOBAL_RANDOMLETTER}

#+++++++++++ Keywords : First Page (Login Page)  +++++++++++#
Fill in Username Field
   [Arguments]    ${username}
      Fill Text       ${LOCATOR_USERNAME_FIELD}      ${username}

Fill in Password Field
   [Arguments]   ${password}
      Fill Secret     ${LOCATOR_PASSWORD_FIELD}      $password

Click Login Button
      Click     ${LOCATOR_LOGIN_BTN}
      Login Waiting Loading

Ignore warning Login
      Wait For Elements State         ${LOCATOR_LOADING_BTN}        hidden         timeout=60
      Sleep    500ms
      ${LOCATOR_YES_MODAL}=    Replace String    ${LOCATOR_MODAL_BTN}    ::buttonname::    Yes
      ${modal_is_show}=     Get Element States        ${LOCATOR_YES_MODAL}     then      bool(value & visible)
      IF  '${modal_is_show}'=='True'
          Wait For Elements State         ${LOCATOR_YES_MODAL}          visible       timeout=5s
          Click    ${LOCATOR_YES_MODAL} 
      END

Verify Welcome page
      Wait For Elements State           ${LOCATOR_WELCOME_TITLE}           visible       timeout=10

Verify Login Page
      Wait For Elements State           ${LOCATOR_USERNAME_FIELD}          visible       timeout=10
      Wait For Elements State           ${LOCATOR_PASSWORD_FIELD}          visible       timeout=10
      Wait For Elements State           ${LOCATOR_LOGIN_BTN}               visible       timeout=10

Verify Menu State
    [Arguments]   ${locator_menu}     ${state}
      Wait Until Keyword Succeeds    1 min   200ms    
      ...    Wait For Elements State     ${locator_menu}     ${state}       timeout=20

#------------------- Keywords : Common functional keyword  -----------------------#
Wait Loading progress
#  Wait for loading progress bar or spinner ${state_val} allowed values = load, domcontentloaded, networkidle, commit    
    [Arguments]    ${locator_progress_bar}=${LOCATOR_LOADING}       ${locator_progress_bar_state}=hidden      ${state_val}=networkidle
      Sleep    500ms
      IF  '${_loadingchecknetwork_}'=='true'
          Wait For Load State           state=${state_val}      timeout=10s
      END
      Wait For Elements State       ${locator_progress_bar}      ${locator_progress_bar_state}        timeout=60


Show Menu Side Parnel
    [Arguments]   ${menuname}
      Wait Loading progress
      ${sidebar_is_visible}=     Get Element States        ${LOCATOR_SIDEBARPANEL}     then    bool(value & visible)
      ${menu_is_visible}=        Get Element States        ${menuname}     then    bool(value & visible)

      IF   '${sidebar_is_visible}'=='False' and '${menu_is_visible}'=='False'
            Click       ${LOCATOR_SIDEBAR_TOGGLE}
            Wait For Elements State       ${LOCATOR_SIDEBARPANEL}       visible     timeout=5s

      ELSE IF   '${sidebar_is_visible}'=='False' and '${menu_is_visible}'=='True'
            Click       ${LOCATOR_SIDEBAR_TOGGLE}
            Wait For Elements State       ${LOCATOR_SIDEBARPANEL}       visible     timeout=5s

      ELSE IF   '${sidebar_is_visible}'=='True' and '${menu_is_visible}'=='True'
            Wait For Elements State       ${LOCATOR_SIDEBARPANEL}       visible     timeout=5s

      ELSE IF   '${sidebar_is_visible}'=='True' and '${menu_is_visible}'=='False'
            Click     ${LOCATOR_SIDEBAR_TOGGLE}
            Wait For Elements State       ${LOCATOR_SIDEBARPANEL}       visible     timeout=5s
      ELSE
            Fail    Check Condition Keyword 'Show Menu Side Parnel'
      END

Hide Menu Side Parnel
      Wait Loading progress
      ${sidebar_is_visible}=    Get Element States        ${LOCATOR_SIDEBARPANEL}     then    bool(value & visible)
      IF   '${sidebar_is_visible}'=='True'
            Click       ${LOCATOR_SIDEBAR_TOGGLE}
            Wait For Elements State       ${LOCATOR_SIDEBARPANEL}       hidden     timeout=10
      ELSE IF  '${sidebar_is_visible}'=='False'
            Wait For Elements State       ${LOCATOR_SIDEBARPANEL}       hidden     timeout=10
      ELSE
            Fail    Check Condition Keyword 'Hide Menu Side Parnel'
      END
      Wait Loading progress

Go to MENU name
    [Arguments]      ${menu_locator}
      Show Menu Side Parnel      ${menu_locator}
      Click       ${menu_locator}
      Sleep   500ms
      Hide Menu Side Parnel

Go to SUBMENU name
      [Arguments]       ${main_menu}       ${submenu}
      Wait For Elements State    ${homemenu}   visible         timeout=500ms
      Click      ${homemenu}
      Sleep   500ms
      Show Menu Side Parnel     ${main_menu}

      ${is_expand_submenu}=      Get Element States        ${LOCATOR_ISEXPAND_SUBMENU}        then    bool(value & visible)
      ${submenu_is_visible}=     Get Element States        ${submenu}    then    bool(value & visible)

      IF   '${is_expand_submenu}'=='True' and '${submenu_is_visible}'=='True'
            Wait For Elements State        ${submenu}     visible       timeout=10s
            Click     ${submenu}

      ELSE IF   '${is_expand_submenu}'=='True' and '${submenu_is_visible}'=='False'
            Click   ${main_menu}
            Wait For Elements State        ${submenu}     visible       timeout=10s
            Click     ${submenu}

      ELSE IF   '${is_expand_submenu}'=='False' and '${submenu_is_visible}'=='False'
            Click   ${main_menu}
            Wait For Elements State        ${submenu}     visible       timeout=10s
            Click   ${submenu}

      ELSE IF   '${is_expand_submenu}'=='False' and '${submenu_is_visible}'=='True'
            Wait For Elements State        ${submenu}      visible       timeout=10s
            Click   ${submenu}
      ELSE
          Fail    Check Condition Keyword 'Go to SUBMENU name'
      END

      Wait Loading progress
      Hide Menu Side Parnel

Verify Page Name is correct
      [Arguments]   ${pagename}    ${locator_pagename}=${LOCATOR_CURRENT_PAGENAME}
      Wait For Elements State       ${LOCATOR_CURRENT_PAGENAME}       visible    timeout=10s
      Get Text      ${LOCATOR_CURRENT_PAGENAME}     contains      ${pagename}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

Alert Warning Notify state should be
      [Arguments]     ${state}    ${locator_notify}
      Wait For Elements State          ${locator_notify}         ${state}        timeout=20

Warning Notify should contain message
   [Arguments]    ${locator_notify}      ${expvalue}
      Wait For Elements State           ${locator_notify}        visible        timeout=20
      Get Text      ${locator_notify}    contains       ${expvalue}

#--------------------- Keywords : Fill data or form ---------------------#
Fill in search field
    [Arguments]    ${locator_field}     ${keyword}     ${sel_attr}=label
      ${TAGNAME}=       Get Property        ${locator_field}        tagName

      Run Keyword If    '${TAGNAME}'=='INPUT'
      ...                Fill Text          ${locator_field}        ${keyword}
      ...    ELSE IF    '${TAGNAME}'=='SELECT'
      ...                Select Options By          ${locator_field}         ${sel_attr}         ${keyword}
      ...       ELSE     Fail     Check condition keyword 'Fill in search field in list page' !!

Fill in data form
    [Arguments]    ${locator_field}     ${value}      ${sel_attr}=label      ${is_checkboxtype}=true    ${is_antdesign}=false
      ${TAGNAME}=     Get Property               ${locator_field}          tagName
      
      IF   '${is_antdesign}'=='true'
            ${TYPE_VAL}=     Set Variable     text
      ELSE      
            ${TYPE_VAL}=    Get Property      ${locator_field}          type
      END

      IF    '${TAGNAME}' in ['INPUT','TEXTAREA'] and '${TYPE_VAL}' not in ['checkbox','radio']
          IF   '${is_antdesign}'=='true'
              Fill Text     ${locator_field}      ${value}
              Wait Loading progress
              Keyboard Key    press    Enter
          ELSE
              Fill Text     ${locator_field}      ${value}
          END

      ELSE IF   '${TAGNAME}'=='SELECT'
          IF  '${_loadingchecknetwork_}'=='true'
              Wait Until Network Is Idle        timeout=30s
          END
          Wait Until Keyword Succeeds    10x    2s 
          ...    Get Select Options      ${locator_field}      validate      any(v["${sel_attr}"] == "${value}" for v in value)
          Select Options By       ${locator_field}      ${sel_attr}     ${value}

      ELSE IF   '${TYPE_VAL}'=='checkbox' and '${value}' in ['check','Check','True','true']        
          IF   '${is_checkboxtype}'=='true'
              Check Checkbox    ${locator_field}
          ELSE    
              ${is_check}=    Run Keyword And Return Status     Get Checkbox State     ${locator_field}    should be      True
              IF   '${is_check}'=='True'
                  Log To Console      checkbox is already checked.
              ELSE
                  Click    ${locator_field}
              END
          END
          Get Checkbox State     ${locator_field}    should be      True

      ELSE IF   '${TYPE_VAL}'=='checkbox' and '${value}' in ['Uncheck','uncheck','False','false']
          IF   '${is_checkboxtype}'=='true'
              Uncheck Checkbox    ${locator_field}
          ELSE    
              ${is_check}=    Run Keyword And Return Status     Get Checkbox State     ${locator_field}    should be      False
              IF   '${is_check}'=='True'
                  Log To Console      checkbox is already unchecked.
              ELSE
                  Click    ${locator_field}
              END
          END
          Get Checkbox State     ${locator_field}    should be      False

      ELSE IF   '${TYPE_VAL}'=='radio'
          Click    ${locator_field}
          Get Checkbox State     ${locator_field}    should be      True

      ELSE IF   '${TAGNAME}' in ('NZ-SELECT-ITEM','NZ-SELECT')
          Click    ${locator_field} 
          ${select_value}=    Replace String    //div[contains(text() ,'::value::')]    ::value::    ${value}
          Click    ${select_value}
          
          IF    '${TAGNAME}'== 'NZ-SELECT-ITEM'
              Get Attribute    ${locator_field}    title    should be    ${value}
          END

      ELSE
          Fail    \nPlease Check Tagname (${TAGNAME}) and Type (${TYPE_VAL}) in locator not found in condition.
      END

Fill in autocomplete data form
    [Arguments]    ${locator_field}     ${value}    ${key}=Enter    ${delaytime}=1200ms
      Type Text    ${locator_field}     ${value}
      Sleep        ${delaytime}
      Keyboard Key     press      ${key}

Clear field data form
    [Arguments]    ${locator_field}
      ${TAGNAME}=     Get Property               ${locator_field}          tagName
      ${TYPE_VAL}=    Get Property               ${locator_field}          type

      IF    '${TAGNAME}' in ['INPUT','TEXTAREA'] and '${TYPE_VAL}' not in ['checkbox','radio']
          Clear Text      ${locator_field}
          Get Text    ${locator_field}   should be     ${EMPTY}

      ELSE IF   '${TAGNAME}'=='SELECT'
          resourcekeywords.Get default value select type    ${locator_field}
          Select Options By      ${locator_field}      value     ${EMPTY}
          Get Selected Options   ${locator_field}      value     should be       ${None}

      ELSE IF   '${TYPE_VAL}'=='checkbox'
          # Get locator for attribute checkbox field     ${locator_field}
          Uncheck Checkbox       ${locator_field}
          Get Checkbox State     ${locator_field}    should be      False
      ELSE
          Fail     \nPlease Check Tagname (${TAGNAME}) and Type (${TYPE_VAL}) in locator not found in condition.
      END

#### Keyword Mass Data ####
Fill out data in form
    [Arguments]    @{fieldname}    &{locator_values}    
        ${amount_field}=       Get Length            ${fieldname} 
        
        FOR  ${index}    IN RANGE      ${amount_field}
            Log    ${fieldname}[${index}] 

            Fill in data form       
            ...    locator_field=${locator_values}[locator.${fieldname}[${index}]]       
            ...    value=${locator_values}[value.${fieldname}[${index}]]      
            ...    sel_attr=${locator_values}[selattr.${fieldname}[${index}]] 
        END

#--------------------- Keywords : Assertion and Get Data ---------------------#
Verify data form
    [Arguments]    ${locator_field}     ${assertion}    ${exp_value}    ${sel_attr}=label    ${ignorcase}=false     ${antdesign}=false
      
      @{tagname_list}=   Create List    
      ...        INPUT    SPAN        H1       H2   H3    H4    H5    H6    
      ...        DIV      TEXTAREA    LABEL    A    TH    TD    FONT
      
      ${TAGNAME}=     Get Property    ${locator_field}    tagName
      IF    '${TAGNAME}'=='INPUT' and '${antdesign}'=='false'
            resourcekeywords.Check Type data field    ${locator_field}
      ELSE     
            Set Suite Variable       ${TYPE_VAL}         text
      END

      IF  '${TAGNAME}' in ${tagname_list} and '${TYPE_VAL}' not in ['radio','checkbox']
        IF  '${ignorcase}'=='false'
                ${GLOBAL_RETURNDATA_VALUE}=     Get Text    ${locator_field}    ${assertion}    ${exp_value}
        ELSE
                ${GLOBAL_RETURNDATA_VALUE}=     Get Text    ${locator_field}
                Should Contain    ${GLOBAL_RETURNDATA_VALUE}    ${exp_value}    ignore_case=True
        END

      ELSE IF   '${TAGNAME}'=='SELECT'
            Wait Until Keyword Succeeds    10x    2s     
            ...    Get Select Options    ${locator_field}      validate    any(v["${sel_attr}"] == "${exp_value}" for v in value)
            ${GLOBAL_RETURNDATA_VALUE}=    Get Selected Options            ${locator_field}    ${sel_attr}     ${assertion}       ${exp_value}

      ELSE IF   '${TYPE_VAL}' in ['radio','checkbox']
          IF  '${TYPE_VAL}' in ['checkbox','radio'] and '${exp_value}' in ['Check','check','True','true']
              ${GLOBAL_RETURNDATA_VALUE}=     Get Checkbox State     ${locator_field}    ${assertion}    True
          ELSE IF  '${TYPE_VAL}'in ['checkbox','radio'] and '${exp_value}' in ['Uncheck',uncheck','False','false']
              ${GLOBAL_RETURNDATA_VALUE}=     Get Checkbox State     ${locator_field}    ${assertion}    False
          END
      
      ELSE IF  '${TYPE_VAL}'=='NZ-SELECT-ITEM'
          ${GLOBAL_RETURNDATA_VALUE}=    Get Attribute    ${locator_field}    title    ${assertion}    ${exp_value}

      ELSE
          Fail    \nPlease Check Tagname (${TAGNAME}) and Type (${TYPE_VAL}) in locator not found in condition.
      END

      Set Global Variable      ${GLOBAL_RETURNDATA_VALUE}

Verify Warning message field
      [Arguments]    ${locator_field}     ${assertion}      ${expectedmsg}
         Get Text    ${locator_field}     ${assertion}      ${expectedmsg}

Verify Field State
   [Arguments]    ${locator_field}    ${state}
      Wait For Elements State         ${locator_field}        ${state}        timeout=2s

Verify Button State
   [Arguments]    ${locator_field}     ${state}
      Wait For Elements State          ${locator_field}       ${state}        timeout=2s


Get Data Value Field
    [Arguments]    ${locator_field}    ${sel_attr}=label  
      
      @{tagname_list}=   Create List    
      ...        INPUT    SPAN        H1       H2   H3    H4    H5    H6    
      ...        DIV      TEXTAREA    LABEL    A    TH    TD    FONT
      
      ${TAGNAME}=     Get Property    ${locator_field}    tagName
      Run Keyword If    '${TAGNAME}'=='INPUT'
      ...                resourcekeywords.Check Type data field    ${locator_field}
      ...       ELSE     Set Suite Variable       ${TYPE_VAL}         text

      IF  '${TAGNAME}' in ${tagname_list} and '${TYPE_VAL}' not in ['radio','checkbox']
            ${GLOBAL_RETURNDATA_VAL}=     Get Text    ${locator_field}   

      ELSE IF   '${TAGNAME}'=='SELECT'
            ${GLOBAL_RETURNDATA_VAL}=    Get Selected Options   ${locator_field}    ${sel_attr}    

      ELSE
            Fail    \nPlease Check Tagname (${TAGNAME}) in locator not found in condition.
      END
      Set Global Variable      ${GLOBAL_RETURNDATA_VAL}

#### Keyword Mass Data ####
Verify data form is correct
    [Arguments]    @{fieldname}    &{arg_values}      
        ${amount_field}=       Get Length            ${fieldname} 

        FOR  ${index}    IN RANGE      ${amount_field}
            Log    ${fieldname}[${index}] 
            Verify data form      
            ...    ${arg_values}[locator.${fieldname}[${index}]]       
            ...    ${arg_values}[assert.${fieldname}[${index}]]    
            ...    ${arg_values}[expected.${fieldname}[${index}]]      
            ...    ${arg_values}[selattr.${fieldname}[${index}]] 
        END

Verify field state in form is correct
    [Arguments]    @{fieldname}    &{locator_values}      
        ${amount_field}=       Get Length            ${fieldname} 
        FOR  ${index}    IN RANGE      ${amount_field}
            Log    ${fieldname}[${index}] 
            IF  '${locator_values}[state_all]'!='true'
                Verify Field State     
                ...    ${locator_values}[locator_${fieldname}[${index}]]       
                ...    ${locator_values}[state_${fieldname}[${index}]] 
            ELSE
                Verify Field State    
                ...    ${locator_values}[locator_${fieldname}[${index}]]     
                ...    ${locator_values}[expectedstate]    
            END   
        END

#--------------------- Handle Data Table ----------------------#
Verify Result of data table
     [Arguments]     ${locator_thead}    ${locator_tbody}   ${rowdata}    ${ignorcase}     ${escape_action}=false    &{expectedresult}
    
      ${amount_th_row}=   Get Element Count         ${locator_thead}/tr
      IF  '${amount_th_row}'=='0'
           ${amount_th_row}=   Get Element Count    ${locator_thead}
           ${amount_col}=      Get Element Count    ${locator_thead}/th
      ELSE
           ${amount_col}=      Get Element Count    ${locator_thead}/tr[${amount_th_row}]/th
      END

      @{colname}=    Create List
      FOR  ${index}    IN RANGE    ${amount_col}
              ${index_col}=   Evaluate    ${index}+1
              
              ${theadfound}=  Run Keyword And Return Status        Wait For Elements State     ${locator_thead}/tr[${amount_th_row}]/th[${index_col}]   visible    timeout=500ms

              IF  '${theadfound}'=='True'
                  ${columnname_val}=    Get Text      ${locator_thead}/tr[${amount_th_row}]/th[${index_col}]
              ELSE
                  ${is_theadindex}=  Run Keyword And Return Status        Wait For Elements State     ${locator_thead}/th[${index_col}]   visible    timeout=500ms
                  IF  ${is_theadindex}=='True'
                      ${columnname_val}=    Get Text      ${locator_thead}/th[${index_col}]
                  ELSE
                      ${columnname_val}=    Set Variable    thead_invible
                  END
              END
              
              ${columnname_val}=    Replace String           ${columnname_val}        \n            ${SPACE}
              ${columnname_val}=    Remove String            ${columnname_val}        ${EMPTY}      ${SPACE}    .     ,     -   /    (    )   _
              ${columnname_val}=    Convert To Lower Case    ${columnname_val}

              IF   '${columnname_val}'!=''
                    IF    '${escape_action}'=='true'
                        Insert Into List    ${colname}    ${index}     ${columnname_val}
                    ELSE
                        IF   '${columnname_val}'!='action'
                            Insert Into List    ${colname}    ${index}     ${columnname_val}
                        END
                    END
              END

      END
      Set Local Variable          @{colname}

      ${amount_col}=      Get Length    ${colname}

      IF  '${amount_col}'=='0'
          Fail      \nPlease Check Amount Column Table header (LOCATOR_THEAD) should greater than 0
      ELSE
            FOR   ${index}    IN RANGE    ${amount_col}
                  ${indexval}=      Evaluate      ${index}+1
                  ${found_col}=     Run Keyword And Return Status    Should Be True    '${expectedresult}[col.${colname}[${index}]]'=='${colname}[${index}]'

                  IF  '${found_col}'=='True'
                              verify result data table    ${locator_tbody}    ${indexval}
                              ...   ${expectedresult}[assert.${colname}[${index}]]       
                              ...   ${expectedresult}[expected.${colname}[${index}]]    
                              ...   ${rowdata}          ${ignorcase}
                  END
            END
      END

Verify result data table (Custom column)
    [Arguments]     ${locator_field}       ${assertion}      ${expresult}    ${ignorcase}=false

      ${TAGNAME}=     Get Property    ${locator_field}    tagName

      Run Keyword If    '${TAGNAME}'=='INPUT'     resourcekeywords.Check Type data field    ${locator_field}
      ...       ELSE     Set Suite Variable       ${TYPE_VAL}       text

      Wait For Elements State           ${locator_field}      visible          timeout=5s
    
    IF    '${ignorcase}'=='false'
      IF   '${TYPE_VAL}' in ['radio','checkbox']
            ${GLOBAL_RETURNDATA_COLUMN}=    Get Checkbox State     ${locator_field}    ${assertion}      ${expresult}
      ELSE
            ${GLOBAL_RETURNDATA_COLUMN}=    Get Text               ${locator_field}    ${assertion}      ${expresult}
      END
    ELSE IF    '${ignorcase}'=='true'
          IF  '${assertion}'=='should be'
                  ${return_val}=        Get Text      ${locator_field}
                  ${return_val}=        Remove String Using Regexp    ${return_val}       ^[ \t]+|[ \t]+$
                  ${expected_data}=     Remove String Using Regexp    ${expresult}        ^[ \t]+|[ \t]+$
                  Should Be Equal     ${return_val}       ${expected_data}       ignore_case=True

          ELSE IF   '${assertion}'=='contains'
                  Should Contain      ${return_val}       ${expected_data}       ignore_case=True
          ELSE
                  Fail    \nPlease check assertion arg. should any 'should be' or 'contains'.
          END
    ELSE
        Fail    Please check $ignorcase arg. should be 'true' or 'false' (default arg. is 'false')
    END

    Set Global Variable      ${GLOBAL_RETURNDATA_COLUMN}

Verify data table result is No Record Found
    [Arguments]     ${locator_tbody}      ${msg_norecord}=${VAR_DEFAULT_NORECORDFOUND}    ${custom_locator}=false
      
      IF   '${custom_locator}'=='false'
          ${locator_norecord}=    set Variable     ${locator_tbody}/tr[1]/td[1]
      ELSE
          ${locator_norecord}=    set Variable     ${locator_norecord}
      END
      
      Wait For Elements State    ${locator_norecord}      visible       timeout=5s
      Get Text                   ${locator_norecord}      contains      ${msg_norecord}

Get Index Row for data table
    [Arguments]   ${locator_tbody}    ${column_index}     ${data_compare}

      Sleep   500ms
      ${is_record_no_data}=        Run Keyword And Return Status    Get Text    ${locator_tbody}/tr[1]/td[1]      should be       ${VAR_DEFAULT_NORECORDFOUND}

      Run Keyword If    '${is_record_no_data}'=='False'    Get row entries of Data Table     ${locator_tbody}
      ...       ELSE    Fail    No records found, please check data table.
      ...                       \nIf you want to verify no record found.
      ...                       Use Keyword : 'Verify data table result is No Record Found'

      FOR    ${index}     IN RANGE    1      ${GLOBAL_ENTRIES_RESULTOFPAGE}+1
         ${INDEXITEM}=          Set Variable    ${index}
         Set Suite Variable     ${INDEXITEM}
         ${getdata}=          Get Text    ${locator_tbody}/tr[${index}]/td[${column_index}]
         ${data_is_true}=     Should Be True     '${getdata}'=='${data_compare}'
         Exit For Loop If     '${data_is_true}'=='True'
      END

      Set Global Variable     ${GLOBAL_INDEXROWITEM}       ${INDEXITEM}


#--------------------- Keywords : Action ---------------------#
Click Expand Search Criteria
      ${criteria_is_hidden}=        Run Keyword And Return Status         Wait For Elements State     ${LOCATOR_SEARCH_CRITERIA_VISIBLE}       hidden       timeout=5s
      Run Keyword If    '${criteria_is_hidden}'=='True'
      ...               Click    ${LOCATOR_SERACH_CRITERIA_BTN}
      ...       ELSE    Log      Search criteria is already expand!

Click Hide Search Criteria
      ${criteria_is_visible}=        Run Keyword And Return Status       Wait For Elements State      ${LOCATOR_SEARCH_CRITERIA_VISIBLE}       visible       timeout=5s
      Run Keyword If    '${criteria_is_visible}'=='True'
      ...               Click    ${LOCATOR_SERACH_CRITERIA_BTN}
      ...       ELSE    Log      Search criteria already hidden!

Click button on list page
     [Arguments]    ${locator_field}
      Click     ${locator_field}

Click button on detail page
     [Arguments]    ${locator_field}
      Click     ${locator_field}

Click xClose button
     [Arguments]    ${locator_field}
      Click     ${locator_field}

Click Upload Button
    [Arguments]   ${locator_uploadfile}
      Click     ${locator_uploadfile}

Choose file to upload
   [Arguments]       ${locator_choosefile}    ${pathfile}
      Wait For Elements State    ${locator_choosefile}       attached       timeout=60s
      Upload File By Selector    ${locator_choosefile}       ${pathfile}

Download data and save file to download folder
    [Arguments]     ${locator_download_btn}
         ${dl_promise}        Promise To Wait For Download
         Click    ${locator_download_btn}

         ${file_obj}=           Wait For    ${dl_promise}
         File Should Exist      ${file_obj}[saveAs]

         Create Directory       ${EXECDIR}${/}testsuite${/}_download_file
         Empty Directory        ${EXECDIR}${/}testsuite${/}_download_file
         Move File              ${file_obj}[saveAs]      ${EXECDIR}${/}testsuite${/}_download_file

         ${filename}=           List Files In Directory    ${EXECDIR}${/}testsuite${/}_download_file

         Move File              ${EXECDIR}${/}testsuite${/}_download_file${/}${filename}[0]      ${EXECDIR}${/}testsuite${/}_download_file${/}${file_obj.suggestedFilename}

         Set Global Variable    ${GLOBAL_PATHFILE}      ${EXECDIR}${/}testsuite${/}_download_file${/}${file_obj.suggestedFilename}
         Set Global Variable    ${GLOBAL_PATHDIR}       ${EXECDIR}${/}testsuite${/}_download_file

Clear Directory download file
    [Arguments]     ${pathdir}
         Empty Directory      ${pathdir}
         Remove Directory     ${pathdir}


#--------------------- Keywords : Handle javascript alert dialog ---------------------#
Click Button and Handle confirmation alert
    [Arguments]     ${locator}        ${action}
      Run Keyword If    '${action}'=='OK'
      ...                Handle Future Dialogs      action=accept
      ...    ELSE IF    '${action}'=='Cancel'
      ...                Handle Future Dialogs      action=dismiss
      ...       ELSE    Fail    Check Argument action should be 'OK' or 'Cancel'

      Click             ${locator}
      Wait For All Promises
      
Click Button and Verify message alert dialog
    [Arguments]   ${locator}      ${text}

      ${promise} =       Promise To    Wait For Alert    action=accept    text=${text}
      Click              ${locator}
      ${text} =          Wait For      ${promise}

Click Button and Get message alert dialog
    [Arguments]   ${locator}
      ${promise}=       Promise To    Wait For Alert    action=accept
      Click             ${locator}
      ${GLOBAL_ALERTMSG}=          Wait For      ${promise}

      Set Global Variable     ${GLOBAL_ALERTMSG}

#--------------------- Keywords : Paging Function ---------------------#

# Example for Page footer: Showing 1 to 10 of 100 entries  [0]- Number of starting entry on a page, [1] - Number of ending entry oon a page, [3] - Total number of entries
Get data paging entries of Data Table
   [Arguments]    ${locator}
      ${get_entriespage}=     Get Text             ${locator}
      ${pattern} =            Set Variable          \\d+   # Regular expression pattern to match numbers
      ${matches_entries} =    Get Regexp Matches    ${get_entriespage}    ${pattern}
      
      Set Global Variable     ${GLOBAL_START_ENTRY_PAGING}          ${matches_entries[0]} 
      Set Global Variable     ${GLOBAL_ENDING_ENTRY_PAGING}         ${matches_entries[1]} 
      Set Global Variable     ${GLOBAL_TOTALENTRIES}                ${matches_entries[2]} 

Pagination Link is visible
    [Arguments]   ${totalpage}
      FOR  ${index}  IN RANGE  1    ${totalpage}+1
           ${indexpage}=    Convert To String    ${index}
           ${LOCATOR_SHOWINGPAGE_LINK}=    Replace String    ${LOCATOR_PAGINATION_LINK}    ::PAGENUM::    ${indexpage}
           Wait For Elements State         ${LOCATOR_PAGINATION_LINK}      visible        timeout=20
      END