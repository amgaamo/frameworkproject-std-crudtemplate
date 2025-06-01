*** Settings ***
Resource    ../../../../resources/utilitykeywords.resource
Resource    ../../../../resources/services/utility-services.resource
Resource    ../_locator_test.robot

Suite Setup     Initialize System and Go to Menu Management Page

*** Variables ***
####  Ant Design - User Management Data Table  ####
${LOCATOR_ANTDESIGN_ADD_BUTTON}                //*[contains(text(),'เพิ่มข้อมูล')]
${LOCATOR_ANTDESIGN_SAVE_BUTTON}               //*[contains(text(),'บันทึก')]
${LOCATOR_ANTDESIGN_SEARCH_BUTTON}             //span[contains(text(),'ค้นหา')]
${LOCATOR_ANTDESIGN_THEAD}                     //*[contains(@class,'ant-table-thead')]     
${LOCATOR_ANTDESIGN_BODY}                      //*[contains(@class,'ant-table-tbody')]     
${LOCATOR_ANTDESIGN_ACTION_BUTTON}             //span[contains(@class,'ant-dropdown-trigger')]
${LOCATOR_ANTDESIGN_LIST_VIEW_EDIT_BUTTON}     //*[contains(text(),'แก้ไข')]
${LOCATOR_ANTDESIGN_BACK_BUTTON}               //*[contains(text(),'ยกเลิก')]


*** Test Cases ***
Edit Sub Menu to Main Menu is successfully
    Request Servive for Create Data Test
    Create Field Dictionary for field sets Menu data    ${create_menuname}    ${create_menuurl}
    datasources.Update Fields From YAML
    ...      ${YAMLPATH_ANT_DESIGN_DATATEST}    switchsubmenu_off_update    @{ANTDESIGN_FIELDS_SET} 
    Set Test Variable    @{ANTDESIGN_FIELDS_SET}       @{GLOBAL_UPDATE_FIELD_SETS} 

    Execute Data Update And Verification
    ...    @{ANTDESIGN_FIELDS_SET}
    ...    locator_button_add=${LOCATOR_ANTDESIGN_ADD_BUTTON}
    ...    is_ant_design=true
    ...    locator_save_btn=${LOCATOR_ANTDESIGN_SAVE_BUTTON}
    ...    modal_dialog_success_btn=สำเร็จ
    ...    locator_search_btn=${LOCATOR_ANTDESIGN_SEARCH_BUTTON}
    ...    list_locator_thead=${LOCATOR_ANTDESIGN_THEAD}
    ...    list_locator_tbody=${LOCATOR_ANTDESIGN_BODY}
    ...    list_rowdata=1
    ...    list_ignorcase=false
    ...    locator_view_button=${LOCATOR_ANTDESIGN_LIST_VIEW_EDIT_BUTTON}
    ...    locator_edit_button=${LOCATOR_ANTDESIGN_LIST_VIEW_EDIT_BUTTON}
    ...    locator_back_button=${LOCATOR_ANTDESIGN_BACK_BUTTON}
    ...    locator_show_view_action=${LOCATOR_ANTDESIGN_ACTION_BUTTON}
    ...    locator_show_edit_action=${LOCATOR_ANTDESIGN_ACTION_BUTTON}

Edit Main Menu to Sub Menu is successfully
    Request Servive for Create Data Test
    Create Field Dictionary for field sets Menu data    ${create_menuname}    ${create_menuurl}
    datasources.Update Fields From YAML
    ...      ${YAMLPATH_ANT_DESIGN_DATATEST}    switchsubmenu_on_update    @{ANTDESIGN_FIELDS_SET} 
    Set Test Variable    @{ANTDESIGN_FIELDS_SET}       @{GLOBAL_UPDATE_FIELD_SETS} 

    Execute Data Update And Verification
    ...    @{ANTDESIGN_FIELDS_SET}
    ...    locator_button_add=${LOCATOR_ANTDESIGN_ADD_BUTTON}
    ...    is_ant_design=true
    ...    locator_save_btn=${LOCATOR_ANTDESIGN_SAVE_BUTTON}
    ...    modal_dialog_success_btn=สำเร็จ
    ...    locator_search_btn=${LOCATOR_ANTDESIGN_SEARCH_BUTTON}
    ...    list_locator_thead=${LOCATOR_ANTDESIGN_THEAD}
    ...    list_locator_tbody=${LOCATOR_ANTDESIGN_BODY}
    ...    list_rowdata=1
    ...    list_ignorcase=false
    ...    locator_view_button=${LOCATOR_ANTDESIGN_LIST_VIEW_EDIT_BUTTON}
    ...    locator_edit_button=${LOCATOR_ANTDESIGN_LIST_VIEW_EDIT_BUTTON}
    ...    locator_back_button=${LOCATOR_ANTDESIGN_BACK_BUTTON}
    ...    locator_show_view_action=${LOCATOR_ANTDESIGN_ACTION_BUTTON}
    ...    locator_show_edit_action=${LOCATOR_ANTDESIGN_ACTION_BUTTON}

*** Keywords ***
Initialize System and Go to Menu Management Page
    commonkeywords.Open Browser and Go to website   ${ONE4ALL_LOGIN_URL}
    commonkeywords.Login System    admin    Netbay@123
    Click    ${ONE4ALL_CONFIG_MAIN_MENU}     
    Click    ${ONE4ALL_CONFIG_SUBMENU}

Call API Service Get Session One4All
      utility-services.Execute API Request
      ...     servicename=service_getsession  
      ...     method=POST
      ...     urlpath=https://10.6.208.81/one-for-all-api/users/getsession
      ...     requestbody={"username":"sysadminqa","password":"Robot@123"}
      ...     headers_type=headers_simple
      ...     expectedstatus=200
      
      Set Suite Variable       ${SESSION_UID}         ${GLOBAL_RESPONSE_JSON}[data][uid]
      Set Suite Variable       ${SESSION__UCODE}      ${GLOBAL_RESPONSE_JSON}[data][ucode]
Request Servive for Create Data Test
    Call API Service Get Session One4All
    &{headers_session_uiducode}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Uid=${SESSION_UID}
    ...    Ucode=${SESSION__UCODE}
        
    commonkeywords.Generate Random Values    4      3
    Set Suite Variable    ${create_menuname}        robotmenu${GLOBAL_RANDOMNO}
    Set Suite Variable    ${create_menuurl}         test/${create_menuname}
    ${body_create_test}=    Catenate    {"icon":"iconx","name":"${create_menuname}","isSubMenu":false,"parentMenuId":"","url":"${create_menuurl}","order":55}
    
    utility-services.Execute API Request
    ...    servicename=create_datatest       method=POST    
    ...    urlpath=https://10.6.208.81/one-for-all-api/users/createmenu  
    ...    requestbody=${body_create_test}
    ...    headers_type=custom_headers
    ...    &{headers_session_uiducode}

    Should Be Equal    '${GLOBAL_RESPONSE_JSON}[status]'    'success'

Create Field Dictionary for field sets Menu data
    [Arguments]    ${original_menuname}    ${original_menu_url}
    &{ANTDESIGN_MENUNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...   locator_field=//*[@name="mmnc-menu-name"]
    ...   locator_view=//*[@name="mmnc-menu-name"]
    ...   value=menuname
    ...   value_original=${original_menuname}
    ...   assert=should be
    ...   listpage_field=ชื่อเมนู
    ...   search_locator=//*[@id="umnl-search-keyword"]


    &{ANTDESIGN_MENUURL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...   locator_field=//*[@name="mmnc-menu-url"]
    ...   locator_view=//*[@name="mmnc-menu-url"]
    ...   value=menuurl
    ...   value_original=${original_menu_url}
    ...   assert=should be
    ...   listpage_field=เมนูUrl

    &{ANTDESIGN_MENUICON_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...   locator_field=(//*[@name="mmnc-menu-icon"])[1]
    ...   locator_view=(//*[@name="mmnc-menu-icon"])[1]
    ...   value=menuicon
    ...   assert=should be


    &{ANTDESIGN_MENUNUMBER_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...   locator_field=(//*[@name="mmnc-menu-icon"])[2]
    ...   locator_view=(//*[@name="mmnc-menu-icon"])[2]
    ...   value=menunumber
    ...   value_original=55
    ...   assert=should be
    ...   listpage_field=ลำดับของเมนู

    &{ANTDESIGN_SWITCHSUBMENU_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//button[contains(@class, "ant-switch")]
    ...    locator_view=//button[contains(@class, "ant-switch")]
    ...    value=switchsubmenu
    ...    is_switchtype=true
    ...    locator_switch_checked=//*[@class="ant-switch ant-switch-checked"]
    ...    assert=should be


    &{ANTDESIGN_MAINPARAMETER_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    wait_field=${EMPTY}
    ...    locator_field=//*[@name="mmnc-menu-parent-id"]
    ...    locator_view=//*[contains(@class, 'nt-select-selection-item')]
    ...    value=mainparameter
    ...    assert=should be


    @{ANTDESIGN_FIELDS_SET}=    Create List
    ...    ${ANTDESIGN_MENUNAME_FIELD}
    ...    ${ANTDESIGN_MENUURL_FIELD}
    ...    ${ANTDESIGN_MENUICON_FIELD}
    ...    ${ANTDESIGN_MENUNUMBER_FIELD}    
    ...    ${ANTDESIGN_SWITCHSUBMENU_FIELD}
    ...    ${ANTDESIGN_MAINPARAMETER_FIELD}
    
    Set Test Variable    @{ANTDESIGN_FIELDS_SET}