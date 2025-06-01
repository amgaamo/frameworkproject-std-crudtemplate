*** Settings ***
Resource    ../../../../resources/utilitykeywords.resource
Resource    ../../../../resources/services/utility-services.resource
Resource    ../_locator_test.robot

Suite Setup    Run Keywords    Request Servive for Create New User Data Test 
...            AND    Initialize System and Go to New User Management Page    Triple T Internet Company Limited    ${IBOX_USERMGMT_MAIN_MENU}
  

*** Variables ***
####  Ant Design - User Management Data Table  ####
${LOCATOR_SEARCH_BUTTON}         Enter
${LOCATOR_THEAD}                 //div[contains(@class, 'ant-table-content')]/table/thead    
${LOCATOR_BODY}                  //div[contains(@class, 'ant-table-content')]/table/tbody  
${LOCATOR_LIST_VIEW_BUTTON}      //*[contains(text(),'ดูข้อมูล')]
${LOCATOR_DELETE_BUTTON}         (//*[contains(text(),'ลบผู้ใช้งาน')])[1]

*** Test Cases ***
Delete User is successfully
    Create Field Dictionary for field sets delete data
    Execute Data Deletion And Verification    
    ...    @{DEL_USERMGMT_FIELDS_SET}
    ...    locator_search_btn=${LOCATOR_SEARCH_BUTTON}
    ...    list_locator_thead=${LOCATOR_THEAD}
    ...    list_locator_tbody=${LOCATOR_BODY}
    ...    list_rowdata=1
    ...    list_ignorcase=false
    ...    locator_show_del_action=${LOCATOR_LIST_VIEW_BUTTON}
    ...    locator_delete_button=${LOCATOR_DELETE_BUTTON}
    ...    delete_confirm_btn=${EMPTY}
    ...    modal_success_btn=ปิดหน้าต่างนี้
    ...    no_record_found=ไม่มีข้อมูล

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
    Set Suite Variable    ${create_email_data}        rbuser_${GLOBAL_RANDOMNO}_del@mail.com    
    ${body_create_user_test}=    Catenate    SEPARATOR=
        ...    {
        ...        "ref": "",
        ...        "cpId": "5e9fcdc8b9f1890010dffa9b",
        ...        "email": "${create_email_data}",
        ...        "firstName": "Jonnydel",
        ...        "lastName": "Babobotdel",
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

Create Field Dictionary for field sets delete data
    &{EMAIL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    value=${create_email_data}
    ...    assert=contains
    ...    listpage_field=อีเมล
    ...    search_locator=//input[@placeholder="พิมพ์ชื่อหรืออีเมลผู้ใช้งาน"]
    
    &{NAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    value=Jonnydel
    ...    assert=contains
    ...    listpage_field=ชื่อนามสกุล
    
    &{LASTNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    value=Babobotdel
    ...    assert=contains
    ...    listpage_field=ชื่อนามสกุล

    @{DEL_USERMGMT_FIELDS_SET}=    Create List    
    ...    ${EMAIL_FIELD}       ${NAME_FIELD}          ${LASTNAME_FIELD}  

    Set Suite Variable    @{DEL_USERMGMT_FIELDS_SET}