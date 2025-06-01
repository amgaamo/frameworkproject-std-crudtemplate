*** Settings ***
Resource    ../../../../resources/utilitykeywords.resource

*** Variables ***
####  Ant Design - User Management Data Table  ####
${LOGIN_URL}            https://checkplusdemo.fyn.com/platform/#/auth/login
${ATTACHMENT_PATH}      ${EXECDIR}${/}resources${/}datatest${/}example${/}test_signature.png

${REGISTER_BTN}                            //*[contains(text(),'Register')]
${LOCATOR_ANTDESIGN_SAVE_BUTTON}           //*[contains(text(),'บันทึก')]
${LOCATOR_ANTDESIGN_SEARCH_BUTTON}         //span[contains(text(),'ค้นหา')]
${LOCATOR_ANTDESIGN_THEAD}                 //*[contains(@class,'ant-table-thead')]     
${LOCATOR_ANTDESIGN_BODY}                  //*[contains(@class,'ant-table-tbody')]     
${LOCATOR_ANTDESIGN_ACTION_BUTTON}         //span[contains(@class,'ant-dropdown-trigger')]
${LOCATOR_ANTDESIGN_LIST_VIEW_BUTTON}      //*[contains(text(),'แก้ไข')]
${LOCATOR_ANTDESIGN_BACK_BUTTON}           //*[contains(text(),'ยกเลิก')]
${LOCATOR_ANTDESIGN_NEXT_BUTTON}           //*[contains(text(),'Next')]


*** Test Cases ***
Create New Registration is successfully
    commonkeywords.Open Browser and Go to website   ${LOGIN_URL}
    Create Field Dictionary for field sets Register data
    datasources.Update Fields From YAML
    ...      ${YAMLPATH_REGISTRATION}    juristic_register    @{REGITRATION_FIELDS_SET} 
    Set Test Variable    @{REGITRATION_FIELDS_SET}       @{GLOBAL_UPDATE_FIELD_SETS} 

    Execute Data Creation And Verification
    ...    @{REGITRATION_FIELDS_SET}
    ...    locator_button_add=${REGISTER_BTN}
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
    ...    need_verify_detail=false
    ...    locator_next_button=${LOCATOR_ANTDESIGN_NEXT_BUTTON}
    ...    number_of_page=4


*** Keywords ***
Create Field Dictionary for field sets Register data
    &{ANTDESIGN_REGISTYPE_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regcus-page1-type"]
    ...    locator_view=//*[@id="regcus-page1-type"]
    ...    value=registype
    ...    select_attr=label
    ...    pageIndex=1
    
    &{ANTDESIGN_TAXID_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regcus-page1-taxid"]
    ...    locator_view=//*[@id="regcus-page1-taxid"]
    ...    value=taxid
    ...    pageIndex=1
    
    &{ANTDESIGN_BRANCH_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-branch"]
    ...    locator_view=//*[@id="regsec-branch"]
    ...    value=branch
    ...    pageIndex=2
    
    &{ANTDESIGN_COMPANYNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-name"]
    ...    locator_view=//*[@id="regsec-name"]
    ...    value=companyname
    ...    select_attr=label
    ...    pageIndex=2
    
    &{ANTDESIGN_HOUSENO_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-houseno"]
    ...    locator_view=//*[@id="regsec-houseno"]
    ...    value=houseno
    ...    pageIndex=2
  
    &{ANTDESIGN_MOO_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-moo"]
    ...    locator_view=//*[@id="regsec-moo"]
    ...    value=moo
    ...    pageIndex=2
  
    &{ANTDESIGN_BUILDING_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-building"]
    ...    locator_view=//*[@id="regsec-building"]
    ...    value=building
    ...    pageIndex=2
   
    &{ANTDESIGN_SOI_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-soi"]
    ...    locator_view=//*[@id="regsec-soi"]
    ...    value=soi
    ...    pageIndex=2
    
    &{ANTDESIGN_STREET_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@name="regsec-street"]
    ...    locator_view=//*[@name="regsec-street"]
    ...    value=street
    ...    pageIndex=2
    
    &{ANTDESIGN_SUBDISTRICT_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[contains(@class,'ant-form-item-control-input-content')]/app-sub-district/input
    ...    locator_view=//*[contains(@class,'ant-form-item-control-input-content')]/app-sub-district/input
    ...    value=subdistrict
    ...    pageIndex=2
    
    &{ANTDESIGN_PHONE_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-phone"]
    ...    locator_view=//*[@id="regsec-phone"]
    ...    value=phone
    ...    pageIndex=2
    
    &{ANTDESIGN_EMAIL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-email"]
    ...    locator_view=//*[@id="regsec-email"]
    ...    value=email
    ...    pageIndex=2
    &{ANTDESIGN_CONTACTNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-contact-name"]
    ...    locator_view=//*[@id="regsec-contact-lastname"]
    ...    value=contactname
    ...    pageIndex=2
    
    &{ANTDESIGN_CONTACTLASTNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-contact-lastname"]
    ...    locator_view=//*[@id="regsec-contact-lastname"]
    ...    value=contactlastname
    ...    pageIndex=2
    
    &{ANTDESIGN_CONTACTPHONE_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-contact-phone"]
    ...    locator_view=//*[@id="regsec-contact-phone"]
    ...    value=contactphone
    ...    pageIndex=2
    
    &{ANTDESIGN_CONTACTEMAIL_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regsec-contact-email"]
    ...    locator_view=//*[@id="regsec-contact-email"]
    ...    value=contactemail
    ...    pageIndex=2
    
    &{ANTDESIGN_ATTACHMENT_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//input[@type='file']
    ...    locator_view=//input[@type='file']
    ...    value=${ATTACHMENT_PATH}
    ...    pageIndex=3
    
    &{ANTDESIGN_USERNAME_FIELD}=    utilitykeywords.Create Field Dictionary for field sets
    ...    locator_field=//*[@id="regcus-page4-username"]
    ...    locator_view=//*[@id="regcus-page4-username"]
    ...    value=username
    ...    pageIndex=4
    
    @{REGITRATION_FIELDS_SET}=    Create List
    ...    ${ANTDESIGN_REGISTYPE_FIELD}
    ...    ${ANTDESIGN_TAXID_FIELD}
    ...    ${ANTDESIGN_BRANCH_FIELD}
    ...    ${ANTDESIGN_COMPANYNAME_FIELD}
    ...    ${ANTDESIGN_HOUSENO_FIELD}
    ...    ${ANTDESIGN_MOO_FIELD}
    ...    ${ANTDESIGN_BUILDING_FIELD}
    ...    ${ANTDESIGN_SOI_FIELD}
    ...    ${ANTDESIGN_STREET_FIELD}
    ...    ${ANTDESIGN_SUBDISTRICT_FIELD}
    ...    ${ANTDESIGN_PHONE_FIELD}
    ...    ${ANTDESIGN_EMAIL_FIELD}
    ...    ${ANTDESIGN_CONTACTNAME_FIELD}
    ...    ${ANTDESIGN_CONTACTLASTNAME_FIELD}
    ...    ${ANTDESIGN_CONTACTPHONE_FIELD}
    ...    ${ANTDESIGN_CONTACTEMAIL_FIELD}
    ...    ${ANTDESIGN_ATTACHMENT_FIELD}
    ...    ${ANTDESIGN_USERNAME_FIELD}
    
    Set Test Variable    @{REGITRATION_FIELDS_SET}     
