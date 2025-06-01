*** Settings ***
Resource    ../../../../resources/utilitykeywords.resource
Resource    ../../../../resources/services/utility-services.resource
Resource    ../_locator_test.robot

Suite Setup     Initialize System and Go to Menu Management Page

*** Variables ***
####  Ant Design - User Management Data Table  ####
${LOCATOR_ANTDESIGN_SEARCH_BUTTON}             //span[contains(text(),'ค้นหา')]
${LOCATOR_ANTDESIGN_THEAD}                     //*[contains(@class,'ant-table-thead')]     
${LOCATOR_ANTDESIGN_BODY}                      //*[contains(@class,'ant-table-tbody')]     
${LOCATOR_ANTDESIGN_ACTION_BUTTON}             //span[contains(@class,'ant-dropdown-trigger')]
${LOCATOR_ANTDESIGN_LIST_DELETE_BUTTON}        //*[contains(text(),'ลบ')]


*** Test Cases ***
Confirm Delete is successfully
    Request Servive for Create Data Test
    Create Field Dictionary for field sets Menu data    ${create_menuname}    ${create_menuurl} 
    Execute Data Deletion And Verification    
    ...    @{ANTDESIGN_FIELDS_SET}
    ...    locator_search_btn=${LOCATOR_ANTDESIGN_SEARCH_BUTTON}   
    ...    list_locator_thead=${LOCATOR_ANTDESIGN_THEAD}  
    ...    list_locator_tbody=${LOCATOR_ANTDESIGN_BODY}    
    ...    list_rowdata=1
    ...    list_ignorcase=true    
    ...    locator_show_del_action=${LOCATOR_ANTDESIGN_ACTION_BUTTON}    
    ...    locator_delete_button=${LOCATOR_ANTDESIGN_LIST_DELETE_BUTTON}    
    ...    delete_confirm_btn=ลบ    
    ...    modal_success_btn=สำเร็จ
    ...    no_record_found=ไม่มีข้อมูล

Cancel Delete is successfully
    Request Servive for Create Data Test
    Create Field Dictionary for field sets Menu data    ${create_menuname}    ${create_menuurl} 
    Execute Data Deletion And Verification    
    ...    @{ANTDESIGN_FIELDS_SET}
    ...    locator_search_btn=${LOCATOR_ANTDESIGN_SEARCH_BUTTON}   
    ...    list_locator_thead=${LOCATOR_ANTDESIGN_THEAD}  
    ...    list_locator_tbody=${LOCATOR_ANTDESIGN_BODY}    
    ...    list_rowdata=1
    ...    list_ignorcase=true    
    ...    locator_show_del_action=${LOCATOR_ANTDESIGN_ACTION_BUTTON}    
    ...    locator_delete_button=${LOCATOR_ANTDESIGN_LIST_DELETE_BUTTON}    
    ...    delete_confirm_btn=ยกเลิก    
    ...    modal_success_btn=${EMPTY}
    ...    no_record_found=found_record

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
    ${body_create_test}=    Catenate    {"icon":"iconx","name":"${create_menuname}","isSubMenu":false,"parentMenuId":"","url":"${create_menuurl}","order":99}
    
    utility-services.Execute API Request
    ...    servicename=create_datatest       method=POST    
    ...    urlpath=https://10.6.208.81/one-for-all-api/users/createmenu  
    ...    requestbody=${body_create_test}
    ...    headers_type=custom_headers
    ...    &{headers_session_uiducode}

    Should Be Equal    '${GLOBAL_RESPONSE_JSON}[status]'    'success'

Create Field Dictionary for field sets Menu data
    [Arguments]    ${menuname_val}    ${menuurl_val}
    &{ANTDESIGN_MENUNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...   value=${menuname_val}
    ...   assert=should be
    ...   listpage_field=ชื่อเมนู
    ...   search_locator=//*[@id="umnl-search-keyword"]

    &{ANTDESIGN_MENUURL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...   value=${menuurl_val}
    ...   assert=should be
    ...   listpage_field=เมนูUrl

    &{ANTDESIGN_MENUNUMBER_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...   value=99
    ...   assert=should be
    ...   listpage_field=ลำดับของเมนู

    @{ANTDESIGN_FIELDS_SET}=      Create List            
    ...    ${ANTDESIGN_MENUNAME_FIELD}
    ...    ${ANTDESIGN_MENUURL_FIELD}
    ...    ${ANTDESIGN_MENUNUMBER_FIELD}    
    
    Set Test Variable    @{ANTDESIGN_FIELDS_SET}  