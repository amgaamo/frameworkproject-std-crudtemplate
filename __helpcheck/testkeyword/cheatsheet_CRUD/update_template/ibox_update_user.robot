*** Settings ***
Resource    ../../../../resources/utilitykeywords.resource
Resource    ../../../../resources/services/utility-services.resource
Resource    ../_locator_test.robot

Suite Setup     Run Keywords    Request Servive for Create New User Data Test
...             AND             Initialize System and Go to New User Management Page     Triple T Internet Company Limited    ${IBOX_USERMGMT_MAIN_MENU}         

*** Variables ***
####  Ant Design - User Management Data Table  ####
${LOCATOR_ADD_BUTTON}            //*[contains(text(),'สร้างผู้ใช้งานใหม่')]
${LOCATOR_SAVE_BUTTON}           (//button[@nztype='primary' and (contains(normalize-space(.), 'บันทึกข้อมูล'))])[1]
${LOCATOR_SEARCH_BUTTON}         Enter
${LOCATOR_THEAD}                 //div[contains(@class, 'ant-table-content')]/table/thead    
${LOCATOR_BODY}                  //div[contains(@class, 'ant-table-content')]/table/tbody  
${LOCATOR_ACTION_BUTTON}         ${EMPTY}
${LOCATOR_LIST_VIEW_BUTTON}      //*[contains(text(),'ดูข้อมูล')]
${LOCATOR_EDIT_BUTTON}           (//*[contains(text(),'แก้ไขข้อมูล')])[1]
${LOCATOR_BACK_BUTTON}           (//button[@aria-label="Close"])[1]


*** Test Cases ***
Update User is successfully
    Create Field Dictionary for field sets create data
    datasources.Update Fields From YAML
    ...      ${YAMLPATH_USER_MANAGEMENT}    update_allfields    @{UPDATE_USERMGMT_FIELDS_SET} 
    Set Test Variable    @{UPDATE_USERMGMT_FIELDS_SET}       @{GLOBAL_UPDATE_FIELD_SETS} 

    Execute Data Update And Verification
    ...    @{UPDATE_USERMGMT_FIELDS_SET}
    ...    locator_button_add=${LOCATOR_ADD_BUTTON}
    ...    is_ant_design=true
    ...    locator_save_btn=${LOCATOR_SAVE_BUTTON}
    ...    modal_dialog_success_btn=ปิดหน้าต่างนี้
    ...    locator_search_btn=${LOCATOR_SEARCH_BUTTON}
    ...    list_locator_thead=${LOCATOR_THEAD}
    ...    list_locator_tbody=${LOCATOR_BODY}
    ...    list_rowdata=1
    ...    list_ignorcase=false
    ...    locator_view_button=${LOCATOR_LIST_VIEW_BUTTON}
    ...    locator_edit_button=${LOCATOR_EDIT_BUTTON}
    ...    locator_back_button=${LOCATOR_BACK_BUTTON}
    ...    locator_show_view_action=${LOCATOR_ACTION_BUTTON}
    ...    locator_show_edit_action=${LOCATOR_LIST_VIEW_BUTTON}
    ...    locator_to_mainlist=${LOCATOR_BACK_BUTTON}

*** Keywords ***
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


Call API Service Get Session i-BOX
      utility-services.Execute API Request
      ...     servicename=service_getsession  
      ...     method=POST
      ...     urlpath=https://demoinvoicechain.netbay.co.th/RD_SERVICE_PROVIDER_TRACKING/public/login-getsession
      ...     requestbody={"username":"nattawut@netbay.co.th","password":"Netbay@123"}
      ...     headers_type=headers_simple
      ...     expectedstatus=200
      
      Set Suite Variable       ${SESSION_UID}         ${GLOBAL_RESPONSE_JSON}[data][data][uid]
      Set Suite Variable       ${SESSION__UCODE}      ${GLOBAL_RESPONSE_JSON}[data][data][ucode]

Request Servive for Create New User Data Test
    
    Call API Service Get Session i-BOX
    &{headers_session_uiducode}=    Create Dictionary
    ...    Content-Type=application/json
    ...    uid=${SESSION_UID}
    ...    ucode=${SESSION__UCODE}
        
    commonkeywords.Generate Random Values    4      3
    Set Suite Variable    ${create_email_data}        rbuser_${GLOBAL_RANDOMNO}@mail.com    
    ${body_create_user_test}=    Catenate    SEPARATOR=
        ...    {
        ...        "ref": "",
        ...        "cpId": "5e9fcdc8b9f1890010dffa9b",
        ...        "email": "${create_email_data}",
        ...        "firstName": "Jonny",
        ...        "lastName": "Babobot",
        ...        "status": "Active",
        ...        "department": "IT Technical",
        ...        "position": "Software Engineer",
        ...        "phoneNo": "021123456",
        ...        "telNo": "0989918812",
        ...        "address": "321/1191 Soi 1, Sukhumvit 101/1, Bangchak, Phrakanong, Bangkok",
        ...        "isCollaborator": false,
        ...        "products": ["d764e9e0-dc44-4dc6-81be-6e7cc1234bd4"]
        ...    }
    
    utility-services.Execute API Request
    ...    servicename=create_user_test       method=POST    
    ...    urlpath=https://demoinvoicechain.netbay.co.th/RD_SERVICE_PROVIDER_TRACKING/user/ibox/upsert    
    ...    requestbody=${body_create_user_test}
    ...    headers_type=custom_headers
    ...    &{headers_session_uiducode}

    Should Be Equal    '${GLOBAL_RESPONSE_JSON}[data]'    'complete process.'

Create Field Dictionary for field sets create data
    &{EMAIL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="email"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[2]/div[2]
    ...    value=email
    ...    value_original=${create_email_data}
    ...    assert=contains
    ...    search_locator=//input[@placeholder="พิมพ์ชื่อหรืออีเมลผู้ใช้งาน"]
    ...    listpage_field=อีเมล
    ...    field_state=disabled
    
    &{NAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="firstName"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]
    ...    value=name
    ...    value_original=Jonny
    ...    assert=contains
    ...    listpage_field=ชื่อนามสกุล
    ...    wait_field=2s
    
    &{LASTNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="lastName"]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]
    ...    value=lastname
    ...    value_original=Babobot
    ...    assert=contains
    ...    listpage_field=ชื่อนามสกุล
  
    &{STATUS_SWITCH_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@formcontrolname="statusRender"]/button
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[3]/div[2]/div[2]/app-user-status-badge/nz-tag/span
    ...    value=status
    ...    value_view=status
    ...    assert=should be
    ...    is_switchtype=true
    ...    locator_switch_checked=//*[contains(@class, "ant-switch-checked")]

    &{DOC2SIGN_CHECH_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=(//*[contains(@class, 'ant-checkbox-input')])[2]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[3]/div[3]/div[2]/nz-list/nz-spin/div/div/div/div[2]/nz-list-item
    ...    value=doc2signcheck
    ...    value_view=doc2signcheck
    ...    assert=should be
    ...    is_checkboxtype=true

    &{ETAX_CHECH_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=(//*[contains(@class, 'ant-checkbox-input')])[1]
    ...    locator_view=//*[@id="cdk-overlay-0"]/div/div[2]/div/div/div[2]/div[2]/div[1]/div[3]/div[3]/div[2]/nz-list/nz-spin/div/div/div/div[1]/nz-list-item
    ...    value=etaxcheck
    ...    value_view=etaxcheck
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
    
    @{UPDATE_USERMGMT_FIELDS_SET}=    Create List    
    ...    ${EMAIL_FIELD}       ${NAME_FIELD}          ${LASTNAME_FIELD}    ${STATUS_SWITCH_FIELD}    ${DOC2SIGN_CHECH_FIELD}   ${ETAX_CHECH_FIELD}     
    ...    ${POSITION_FIELD}    ${DEPARTMENT_FIELD}    ${WORKADDR_FIELD}    ${PHONENUMBER_FIELD}      ${MOBILENUMBER_FIELD}
    

    Set Suite Variable    @{UPDATE_USERMGMT_FIELDS_SET}
    