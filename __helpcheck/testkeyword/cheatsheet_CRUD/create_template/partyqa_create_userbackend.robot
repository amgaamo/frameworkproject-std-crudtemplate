*** Settings ***
Resource    ../../../../resources/utilitykeywords.resource
Resource    ../_locator_test.robot
Suite Setup     Initialize System and Go to New Back office User Management Page

*** Variables ***
####  Ant Design - User Management Data Table  ####
${SIGNATURE_USER_PATH}    ${EXECDIR}${/}resources${/}datatest${/}example${/}test_signature.png

${LOCATOR_ADD_BUTTON}            //*[contains(text(),'เพิ่มข้อมูลผู้ใช้')]
${LOCATOR_SAVE_BUTTON}           //*[contains(text(),'ยืนยัน')]
${LOCATOR_SEARCH_BUTTON}         //*[@id="manage-regis-search"]
${LOCATOR_THEAD}                 //table[contains(@class, 'table')]/thead    
${LOCATOR_BODY}                  //table[contains(@class, 'table')]/tbody          
${LOCATOR_LIST_VIEW_BUTTON}      //*[contains(@id,'view-action')]
${LOCATOR_BACK_BUTTON}           //*[@id="back-btn"]

*** Test Cases ***
Create New Back office User is successfully
    Create Field Dictionary for field sets create data
    datasources.Update Fields From YAML
    ...      ${YAMLPATH_BACKOFFICE_USER}    allfields    @{BACKOFFICE_USERMGMT_FIELDS_SET} 
    Set Test Variable    @{BACKOFFICE_USERMGMT_FIELDS_SET}       @{GLOBAL_UPDATE_FIELD_SETS} 

    Execute Data Creation And Verification
    ...    @{BACKOFFICE_USERMGMT_FIELDS_SET}
    ...    locator_button_add=${LOCATOR_ADD_BUTTON}
    ...    is_ant_design=true
    ...    locator_save_btn=${LOCATOR_SAVE_BUTTON}
    ...    modal_dialog_success_btn=ตกลง
    ...    locator_search_btn=${LOCATOR_SEARCH_BUTTON}
    ...    list_locator_thead=${LOCATOR_THEAD}
    ...    list_locator_tbody=${LOCATOR_BODY}
    ...    list_rowdata=1
    ...    list_ignorcase=false
    ...    locator_show_action=${EMPTY}
    ...    locator_view_button=${LOCATOR_LIST_VIEW_BUTTON}
    ...    locator_back_button=${LOCATOR_BACK_BUTTON}
    ...    need_verify_detail=true

*** Keywords ***
Initialize System and Go to New Back office User Management Page
    commonkeywords.Open Browser and Go to website   ${PARTY_LOGIN_URL}
    commonkeywords.Login System    admin3    Netbay@123
    Click    ${PARTY_CONFIG_MAIN_MENU}     
    Click    ${PARTY_CONFIG_SUBMENU}

Create Field Dictionary for field sets create data
    &{TITLE_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//input[@id="title"]
    ...    locator_view=//input[@id="title"]
    ...    value=นาย

    &{NAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="firstName"]
    ...    locator_view=//*[@id="firstName"]
    ...    value=name
    ...    search_locator=//*[@id="fullname"]
    ...    listpage_field=ชื่อนามสกุล
        
    &{LASTNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="lastName"]
    ...    locator_view=//*[@id="lastName"]
    ...    value=lastname
    ...    assert=contains
    ...    listpage_field=ชื่อนามสกุล
    
    &{POSITION_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//input[@id="gid"]
    ...    locator_view=//*[@id="gid"]/nz-select-top-control/nz-select-item
    ...    value=position
    
    &{EMAIL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="userEmail"]
    ...    locator_view=//*[@id="userEmail"]
    ...    value=email
    
    &{USERNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="username"]
    ...    locator_view=//*[@id="username"]
    ...    value=username
    ...    assert=should be

    &{PASSWORD_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="password"]
    ...    locator_view=//*[@id="password"]
    ...    value=password
    ...    assert=should be
    ...    skip_verify_field=true
    
    &{ATTACHSIGNATURE_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="upload-file-signature"]
    ...    locator_view=//*[@id="upload-file-signature"]
    ...    value=${SIGNATURE_USER_PATH}
    ...    assert=should be
    ...    skip_verify_field=true
    
    &{SUBDISTRICT_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="sub-district"]/nz-select-top-control/nz-select-search/input
    ...    locator_view=//*[@id="sub-district"]/nz-select-top-control/nz-select-item
    ...    value=subdistrict

    &{DISTRICT_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="districtName"]
    ...    locator_view=//*[@id="districtName"]
    ...    value=district
   
    &{PROVINCE_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="provinceName"]
    ...    locator_view=//*[@id="provinceName"]
    ...    value=province
    
    @{BACKOFFICE_USERMGMT_FIELDS_SET}=    Create List
    ...    ${TITLE_FIELD}
    ...    ${NAME_FIELD}
    ...    ${LASTNAME_FIELD}
    ...    ${POSITION_FIELD}
    ...    ${EMAIL_FIELD}
    ...    ${USERNAME_FIELD}
    ...    ${PASSWORD_FIELD}
    ...    ${ATTACHSIGNATURE_FIELD}
    ...    ${SUBDISTRICT_FIELD}
    ...    ${DISTRICT_FIELD}
    ...    ${PROVINCE_FIELD}
    
    Set Test Variable    @{BACKOFFICE_USERMGMT_FIELDS_SET}