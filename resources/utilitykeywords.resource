*** Settings ***
Resource   commonkeywords.resource

*** Keywords ***
Create Field Dictionary for field sets
    [Arguments]   ${locator_field}=${EMPTY}     ${locator_view}=${EMPTY}                
    ...           ${value}=${EMPTY}             ${value_view}=None             ${value_original}=None
    ...           ${select_attr}=label          ${is_checkboxtype}=${EMPTY}    ${is_switchtype}=${EMPTY}       ${locator_switch_checked}=${EMPTY}          
    ...           ${assert}=contains            ${field_state}=editable        ${wait_field}=${EMPTY}
    ...           ${listpage_field}=None        ${search_locator}=None          
    ...           ${skip_verify_field}=False
    ...           ${pageIndex}=1                 

    ${assert}=    Set Variable If    '${is_checkboxtype}' == 'True'      should be     ${assert}
    ${assert}=    Set Variable If    '${is_switchtype}' == 'True'        should be     ${assert}

    &{field}=    Create Dictionary    
    ...    locator_field=${locator_field}
    ...    locator_view=${locator_view}
    ...    value=${value}
    ...    select_attr=${select_attr}
    ...    is_checkboxtype=${is_checkboxtype}
    ...    is_switchtype=${is_switchtype}
    ...    locator_switch_checked=${locator_switch_checked}
    ...    assert=${assert}
    ...    skip_verify_field=${skip_verify_field}
    ...    field_state=${field_state}
    ...    pageIndex=${pageIndex}
    ...    wait_field=${wait_field}
    
    # เพิ่ม key เฉพาะเมื่อไม่ใช่ ${None}
    IF    '${listpage_field}' != 'None'
        Set To Dictionary    ${field}    listpage_field=${listpage_field}
    END    
    IF    '${search_locator}' != 'None'
        Set To Dictionary    ${field}    search_locator=${search_locator}
    END  
    IF    '${value_view}' != 'None'
        Set To Dictionary    ${field}    value_view=${value_view}
    END  
    IF    '${value_original}' != 'None'
        Set To Dictionary    ${field}    value_original=${value_original}
    END  

    RETURN    ${field}

Execute Data Creation And Verification
    [Arguments]     @{field_sets}                  
    ...             ${locator_button_add}               ${is_ant_design}           ${locator_save_btn}                    ${modal_dialog_success_btn}     ${locator_search_btn}   
    ...             ${list_locator_thead}               ${list_locator_tbody}      ${list_rowdata}                        ${list_ignorcase} 
    ...             ${locator_view_button}              ${locator_back_button}     ${locator_show_action}=${EMPTY}        ${need_verify_detail}=true
    ...             ${locator_next_button}=${EMPTY}     ${number_of_page}=1
        
    commonkeywords.Wait Loading progress
    commonkeywords.Click button on list page    ${locator_button_add}
    commonkeywords.Wait Loading progress
    
    Log Many    @{field_sets}

    FOR    ${current_page}    IN RANGE    1    ${number_of_page}+1
        Log    \nFilling field for Page ${current_page} of ${number_of_page} ...    console=True
        
        # กรองเฉพาะฟิลด์ที่อยู่ในหน้าปัจจุบัน ด้วย Evaluate
        @{current_page_fields}    Evaluate    [field for field in $field_sets if str(field.get('pageIndex')) == '${current_page}']
        
        # กรอกข้อมูลเฉพาะฟิลด์ในหน้านี้
        IF    ${current_page_fields}                
            commonkeywords.Fill In All Fields In Form
            ...    @{current_page_fields}
            ...    is_ant_design=${is_ant_design}
        END

        # ไปหน้าถัดไปถ้ายังไม่ใช่หน้าสุดท้าย
        IF    ${current_page} < ${number_of_page}
             commonkeywords.Click button on detail page    ${locator_next_button}
        END    
    END

    # Click Save Button
    Click Button and Handle Modal Dialog    ${locator_save_btn}       ${modal_dialog_success_btn}

    IF  '${need_verify_detail}'=='true'
        # Verify Data Creation - List Page
        commonkeywords.Filter Search Data And Verify Results    
        ...    @{field_sets}
        ...    locator_search_btn=${locator_search_btn}
        ...    list_locator_thead=${list_locator_thead}
        ...    list_locator_tbody=${list_locator_tbody}
        ...    list_rowdata=${list_rowdata}
        ...    list_ignorcase=${list_ignorcase}
        ...    Search_for=create
        
        Log    \nVerify Data Creation - Detail Page in progress ...    console=True

        ${is_show_action}=    Evaluate    repr("""${locator_show_action}""") == "''"

            IF   ${is_show_action}
                commonkeywords.Click button on list page    ${locator_view_button}
            ELSE
                commonkeywords.Click button on list page    ${locator_show_action}
                commonkeywords.Click button on list page    ${locator_view_button}
            END 
            
            commonkeywords.Wait Loading progress

    # Verify Data Creation - Detail Page
            commonkeywords.Validate All Fields In Form
            ...    @{field_sets}
            ...    is_ant_design=${is_ant_design}

            commonkeywords.Click button on detail page    ${locator_back_button}
            commonkeywords.Wait Loading progress
            Wait For Elements State    selector=${locator_button_add}    state=visible    timeout=10s
    ELSE
         Log    \nVerify Data Creation - Detail Page is not required  console=True
    END


Execute Data Update And Verification
    [Arguments]     @{field_sets}                  
    ...             ${locator_button_add}                   ${is_ant_design}                       ${locator_save_btn}                    ${modal_dialog_success_btn}     ${locator_search_btn}   
    ...             ${list_locator_thead}                   ${list_locator_tbody}                  ${list_rowdata}                        ${list_ignorcase} 
    ...             ${locator_view_button}                  ${locator_edit_button}                 ${locator_back_button}             
    ...             ${locator_show_view_action}=${EMPTY}    ${locator_show_edit_action}={EMPTY}    ${locator_to_mainlist}=${EMPTY}    

        commonkeywords.Wait Loading progress
        
        # Search Data fot Update
        commonkeywords.Filter Search Data And Verify Results    
        ...    @{field_sets}
        ...    locator_search_btn=${locator_search_btn}
        ...    list_locator_thead=${list_locator_thead}
        ...    list_locator_tbody=${list_locator_tbody}
        ...    list_rowdata=${list_rowdata}
        ...    list_ignorcase=${list_ignorcase}
        ...    Search_for=create

        # Click Edit Button
        ${is_show_action}=    Evaluate    repr("""${locator_show_edit_action}""") == "''"
        IF   ${is_show_action}
            commonkeywords.Click button on list page    ${locator_edit_button}
        ELSE
            commonkeywords.Click button on list page    ${locator_show_edit_action}
            commonkeywords.Click button on list page    ${locator_edit_button}
        END 
        commonkeywords.Wait Loading progress
        commonkeywords.Fill In All Fields In Form
        ...    @{field_sets}
        ...    is_ant_design=${is_ant_design}

        # Click Save Button
        Click Button and Handle Modal Dialog    ${locator_save_btn}       ${modal_dialog_success_btn}

        ${is_close_to_mainlist}=    Evaluate    repr("""${locator_to_mainlist}""") != "''" 
        IF   ${is_close_to_mainlist}
            commonkeywords.Click button on detail page    ${locator_to_mainlist}
            commonkeywords.Wait Loading progress
            Wait For Elements State    selector=${locator_button_add}    state=visible    timeout=5s   
        ELSE
            commonkeywords.Wait Loading progress
            Wait For Elements State    selector=${locator_button_add}    state=visible    timeout=5s       
        END

        # Verify Data Creation - List Page
        commonkeywords.Filter Search Data And Verify Results    
        ...    @{field_sets}
        ...    locator_search_btn=${locator_search_btn}
        ...    list_locator_thead=${list_locator_thead}
        ...    list_locator_tbody=${list_locator_tbody}
        ...    list_rowdata=${list_rowdata}
        ...    list_ignorcase=${list_ignorcase}
        ...    Search_for=update      

        Log    \nVerify Data Creation - Detail Page in progress ...    console=True

        ${is_show_action}=    Evaluate    repr("""${locator_show_view_action}""") == "''"
        IF   ${is_show_action}
            commonkeywords.Click button on list page    ${locator_view_button}
        ELSE
            commonkeywords.Click button on list page    ${locator_show_view_action}
            commonkeywords.Click button on list page    ${locator_view_button}
        END 
            
        commonkeywords.Wait Loading progress

        # Verify Data Creation - Detail Page
        commonkeywords.Validate All Fields In Form
        ...    @{field_sets}
        ...    is_ant_design=${is_ant_design}

        commonkeywords.Click button on detail page    ${locator_back_button}
        commonkeywords.Wait Loading progress
        Wait For Elements State    selector=${locator_button_add}    state=visible    timeout=5s       


Execute Data Deletion And Verification
    [Arguments]     @{field_sets}                    ${locator_search_btn}          ${list_locator_thead}       ${list_locator_tbody}    ${list_rowdata}    ${list_ignorcase}    
    ...             ${locator_show_del_action}       ${locator_delete_button}       ${delete_confirm_btn}       ${modal_success_btn}     ${no_record_found}
    commonkeywords.Wait Loading progress
    commonkeywords.Filter Search Data And Verify Results    
    ...    @{field_sets}
    ...    locator_search_btn=${locator_search_btn}
    ...    list_locator_thead=${list_locator_thead}
    ...    list_locator_tbody=${list_locator_tbody}
    ...    list_rowdata=${list_rowdata}
    ...    list_ignorcase=${list_ignorcase}
    ...    Search_for=create

    # Click Delete Button
    ${is_show_action}=    Evaluate    repr("""${locator_show_del_action}""") == "''"
    IF   ${is_show_action}
        commonkeywords.Click button on list page    ${locator_delete_button}
    ELSE
        commonkeywords.Click button on list page    ${locator_show_del_action}
        commonkeywords.Click button on list page    ${locator_delete_button}
    END 
        commonkeywords.Wait Loading progress
    
    # Click Delete Confirm Button
    ${is_delete_confirm_btn}=    Evaluate    repr("""${delete_confirm_btn}""") == "''"
    IF   ${is_delete_confirm_btn}
        commonkeywords.Click Modal Button    ${modal_success_btn}
    ELSE
        IF  '${delete_confirm_btn}' in ('Confirm', 'Yes', 'Delete', 'ลบข้อมูล', 'ลบ', 'ลบเอกสาร','ยืนยัน')
            commonkeywords.Click Modal Button    ${delete_confirm_btn}    timeout=3s
            commonkeywords.Wait Loading progress
            commonkeywords.Click Modal Button    ${modal_success_btn}    timeout=3s
            commonkeywords.Verify data table result is No Record Found    ${list_locator_tbody}    ${no_record_found}
        ELSE IF  '${delete_confirm_btn}' in ('Cancel', 'No', 'Close', 'Back', 'ยกเลิก', 'กลับสู่เมนูหลัก', 'ปิด','ภายหลัง')
            commonkeywords.Click Modal Button    ${delete_confirm_btn}
        ELSE
            Fail    '\nDelete Confirm Button is not found. Please check keyword: Execute Data Deletion And Verification'
        END
    END 
    commonkeywords.Wait Loading progress
    
    # Verify Data Deletion - List Page
  commonkeywords.Filter Search Data And Verify Results    
        ...    @{field_sets}
        ...    locator_search_btn=${locator_search_btn}
        ...    list_locator_thead=${list_locator_thead}
        ...    list_locator_tbody=${list_locator_tbody}
        ...    list_rowdata=${list_rowdata}
        ...    list_ignorcase=${list_ignorcase}
        ...    Search_for=delete
        ...    no_record_found=${no_record_found}


