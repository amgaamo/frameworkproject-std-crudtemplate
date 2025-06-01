*** Settings ***
Resource    ../../../../resources/utilitykeywords.resource
Resource    ../_locator_test.robot

Suite Setup   Run Keywords      commonkeywords.Open Browser and Go to website   ${ONE4ALL_LOGIN_URL}
...           AND               commonkeywords.Login System    admin    Netbay@123
...           AND               Click    ${ONE4ALL_CONFIG_MAIN_MENU}     
...           AND               Click    ${ONE4ALL_CONFIG_SUBMENU}

Test Template    Template for Create New Menu Management

*** Variables ***
####  Ant Design - User Management Data Table  ####
${LOCATOR_ANTDESIGN_ADD_BUTTON}            //*[contains(text(),'เพิ่มข้อมูล')]
${LOCATOR_ANTDESIGN_SAVE_BUTTON}           //*[contains(text(),'บันทึก')]
${LOCATOR_ANTDESIGN_SEARCH_BUTTON}         //span[contains(text(),'ค้นหา')]
${LOCATOR_ANTDESIGN_THEAD}                 //*[contains(@class,'ant-table-thead')]     
${LOCATOR_ANTDESIGN_BODY}                  //*[contains(@class,'ant-table-tbody')]     
${LOCATOR_ANTDESIGN_ACTION_BUTTON}         //span[contains(@class,'ant-dropdown-trigger')]
${LOCATOR_ANTDESIGN_LIST_VIEW_BUTTON}      //*[contains(text(),'แก้ไข')]
${LOCATOR_ANTDESIGN_BACK_BUTTON}           //*[contains(text(),'ยกเลิก')]


*** Test Cases ***
Create New Sub Menu is successfully     switchsubmenu_on
Create New Main Menu is successfully    switchsubmenu_off
    
*** Keywords ***
Template for Create New Menu Management
    [Arguments]    ${scenario_key} 

    Create Field Dictionary for field sets create data
    datasources.Update Fields From YAML
    ...      ${YAMLPATH_ANT_DESIGN_DATATEST}    ${scenario_key}     @{ANTDESIGN_FIELDS_SET} 
    Set Test Variable    @{ANTDESIGN_FIELDS_SET}       @{GLOBAL_UPDATE_FIELD_SETS} 

    Execute Data Creation And Verification
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
    ...    locator_show_action=${LOCATOR_ANTDESIGN_ACTION_BUTTON}
    ...    locator_view_button=${LOCATOR_ANTDESIGN_LIST_VIEW_BUTTON}
    ...    locator_back_button=${LOCATOR_ANTDESIGN_BACK_BUTTON}

Create Field Dictionary for field sets create data
    &{ANTDESIGN_MENUNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@name="mmnc-menu-name"]
    ...    locator_view=//*[@name="mmnc-menu-name"]
    ...    value=menuname
    ...    assert=should be
    ...    listpage_field=ชื่อเมนู
    ...    search_locator=//*[@id="umnl-search-keyword"]
    
    &{ANTDESIGN_MENUURL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@name="mmnc-menu-url"]
    ...    locator_view=//*[@name="mmnc-menu-url"]
    ...    value=menuurl
    ...    assert=should be
    ...    listpage_field=เมนูUrl
    
    &{ANTDESIGN_MENUICON_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=(//*[@name="mmnc-menu-icon"])[1]
    ...    locator_view=(//*[@name="mmnc-menu-icon"])[1]
    ...    value=menuicon
    ...    assert=should be
    
    &{ANTDESIGN_MENUNUMBER_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=(//*[@name="mmnc-menu-icon"])[2]
    ...    locator_view=(//*[@name="mmnc-menu-icon"])[2]
    ...    value=menunumber
    ...    assert=should be
    ...    listpage_field=ลำดับของเมนู
    
    &{ANTDESIGN_SWITCHSUBMENU_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//button[contains(@class, "ant-switch")]
    ...    locator_view=//button[contains(@class, "ant-switch")]
    ...    value=switchsubmenu
    ...    is_switchtype=true
    ...    locator_switch_checked=//*[@class="ant-switch ant-switch-checked"]
    ...    assert=should be
    
    &{ANTDESIGN_MAINPARAMETER_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
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