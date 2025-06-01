*** Settings ***
Resource    ../../../../resources/utilitykeywords.resource
Resource    ../_locator_test.robot

Suite Setup     Initialize System and Go to New User Management Page    
                ...    Triple T Internet Company Limited    ${IBOX_USERMGMT_MAIN_MENU}

Test Template    Template for Create New User Management

*** Variables ***
####  Ant Design - User Management Data Table  ####
${LOCATOR_ADD_BUTTON}            //*[contains(text(),'สร้างผู้ใช้งานใหม่')]
${LOCATOR_SAVE_BUTTON}           (//button[@nztype='primary' and (contains(normalize-space(.), 'สร้างผู้ใช้งาน'))])[1]
${LOCATOR_SEARCH_BUTTON}         Enter
${LOCATOR_THEAD}                 //div[contains(@class, 'ant-table-content')]/table/thead    
${LOCATOR_BODY}                  //div[contains(@class, 'ant-table-content')]/table/tbody  
${LOCATOR_ACTION_BUTTON}         ${EMPTY}
${LOCATOR_LIST_VIEW_BUTTON}      //*[contains(text(),'ดูข้อมูล')]
${LOCATOR_BACK_BUTTON}           (//button[@aria-label="Close"])[1]

*** Test Cases ***
Create New User is successfully all fields       allfields
Create New User is successfully with required fields   requiredfields

*** Keywords ***
Template for Create New User Management
    [Arguments]    ${scenario_key}
    [Documentation]    Template for Create New User Management
    
    Create Field Dictionary for field sets update data
    
    IF  '${scenario_key}' == 'allfields'
        Set Test Variable    @{USERMGMT_FIELDS_SET}       @{USERMGMT_FIELDS_SET}
    ELSE IF  '${scenario_key}' == 'requiredfields'
        Set Test Variable    @{USERMGMT_FIELDS_SET}       @{REQUIRED_USERMGMT_FIELDS_SET}
    END

    datasources.Update Fields From YAML
    ...      ${YAMLPATH_USER_MANAGEMENT}    ${scenario_key}    @{USERMGMT_FIELDS_SET} 
    Set Test Variable    @{USERMGMT_FIELDS_SET}       @{GLOBAL_UPDATE_FIELD_SETS} 

    Execute Data Creation And Verification
    ...    @{USERMGMT_FIELDS_SET}
    ...    locator_button_add=${LOCATOR_ADD_BUTTON}
    ...    is_ant_design=true
    ...    locator_save_btn=${LOCATOR_SAVE_BUTTON}
    ...    modal_dialog_success_btn=กลับหน้าหลัก
    ...    locator_search_btn=${LOCATOR_SEARCH_BUTTON}
    ...    list_locator_thead=${LOCATOR_THEAD}
    ...    list_locator_tbody=${LOCATOR_BODY}
    ...    list_rowdata=1
    ...    list_ignorcase=false
    ...    locator_show_action=${LOCATOR_ACTION_BUTTON}
    ...    locator_view_button=${LOCATOR_LIST_VIEW_BUTTON}
    ...    locator_back_button=${LOCATOR_BACK_BUTTON}
    ...    need_verify_detail=true

Initialize System and Go to New User Management Page
    [Arguments]    ${companyname}    ${menuname}
        commonkeywords.Open Browser and Go to website   ${IBOX_LOGIN_URL}
        commonkeywords.Login System    nattawut@netbay.co.th    Netbay@123
        Click        ${IBOX_CONFIG_MAIN_MENU}    
        commonkeywords.Fill in search field         ${IBOX_LOCATOR_SEARCH_COMPANY_NAME}   	 ${companyname}
        commonkeywords.Wait Loading progress
        commonkeywords.Click button on list page    ${IBOX_LOCATOR_SEARCH_COMPANY_NAME_BTN}
        commonkeywords.Wait Loading progress
        commonkeywords.Click button on list page    ${IBOX_LOCATOR_VIEW_COMPANY_NAME}
        commonkeywords.Wait Loading progress
        Click       ${menuname}
        commonkeywords.Wait Loading progress
        commonkeywords.Get Information New Page Open
        commonkeywords.Switch Another Open Page        ${GLOBAL_NEWPAGE} 
        commonkeywords.Wait Loading progress  

Create Field Dictionary for field sets update data
    &{EMAIL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="email"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[2]/div[2]
    ...    value=email
    ...    assert=contains
    ...    listpage_field=อีเมล
    
    &{NAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="firstName"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]
    ...    value=name
    ...    assert=contains
    ...    search_locator=//input[@placeholder="พิมพ์ชื่อหรืออีเมลผู้ใช้งาน"]
    ...    listpage_field=ชื่อนามสกุล
    
    &{LASTNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="lastName"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]
    ...    value=lastname
    ...    assert=contains
    ...    listpage_field=ชื่อนามสกุล
  
    &{STATUS_SWITCH_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="statusRender"]/button
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[3]/div[2]/div[2]/app-user-status-badge/nz-tag/span
    ...    value=status
    ...    value_view=status
    ...    assert=should be
    ...    is_switchtype=true
    ...    locator_switch_checked=//*[@class="ant-switch ant-switch-checked"]

    &{DOC2SIGN_CHECH_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=(//*[contains(@class, 'ant-checkbox-input')])[2]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[3]/div[3]/div[2]/nz-list/nz-spin/div/div/div/div[1]/nz-list-item
    ...    value=doc2signcheck
    ...    value_view=doc2signcheck
    ...    assert=should be
    ...    is_checkboxtype=true

    &{POSITION_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="position"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[3]/div[2]
    ...    value=position
    ...    assert=should be    

    &{DEPARTMENT_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="department"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[4]/div[2]
    ...    value=department
    ...    assert=should be

    &{WORKADDR_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="address"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[5]/div[2]
    ...    value=workaddress
    ...    assert=should be

    &{PHONENUMBER_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="telNo"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[6]/div[2]
    ...    value=phonenumber
    ...    assert=contains
    
    &{MOBILENUMBER_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="phoneNo"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[7]/div[2]
    ...    value=mobilenumber
    ...    assert=contains
    
    @{USERMGMT_FIELDS_SET}=    Create List    
    ...    ${EMAIL_FIELD}       ${NAME_FIELD}          ${LASTNAME_FIELD}    ${STATUS_SWITCH_FIELD}    ${DOC2SIGN_CHECH_FIELD}    
    ...    ${POSITION_FIELD}    ${DEPARTMENT_FIELD}    ${WORKADDR_FIELD}    ${PHONENUMBER_FIELD}      ${MOBILENUMBER_FIELD}
    
    @{REQUIRED_USERMGMT_FIELDS_SET}=    Create List    
    ...    ${EMAIL_FIELD}       ${NAME_FIELD}          ${LASTNAME_FIELD}    ${STATUS_SWITCH_FIELD}    ${DOC2SIGN_CHECH_FIELD}    

    Set Test Variable    @{USERMGMT_FIELDS_SET}    
    Set Test Variable    @{REQUIRED_USERMGMT_FIELDS_SET}