*** Settings ***
Library     Browser         retry_assertions_for=0:00:05     run_on_failure=Take Screenshot \ fail-screenshot-{index} \ fileType=jpeg \ quality=25
Library     Collections
Library     String
Library     OperatingSystem
Library     RequestsLibrary
Library     CSVLib
Library     DateTime
Library     JSONLibrary
Library     pabot.PabotLib
Library     ImapLibrary2
Library     yaml

Resource    config-properties.resource
Resource    datasources.resource
Resource    services/main-services.resource

*** Keywords ***
Get Value Environment
      ${PROTOCOL}=             Get Environment Variable         PROTOCOL_PROJECT
      ${DOMAIN}=               Get Environment Variable         DOMAIN_PROJECT
      ${URLPATH}=              Get Environment Variable         URLPATH_PROJECT
      ${APIURLPATH}=           Get Environment Variable         API_URLPATH_PROJECT
      ${ENV_BROWSER}=          Get Environment Variable         RUN_BROWSER

      Set Global Variable      ${PROTOCOL}
      Set Global Variable      ${DOMAIN}
      Set Global Variable      ${URLPATH}
      Set Global Variable      ${APIURLPATH}
      Set Global Variable      ${ENV_BROWSER}

Set Data for Run Automated Test
      IF  '${_fixdata_}'=='true'
          Set Global Variable     ${URLTEST}              ${VAR_PROTOCOL}://${VAR_IPSERV}
          Set Global Variable     ${API_URLPATH_TEST}     ${VAR_API_SUBDIRECTORY}

      ELSE IF   '${_fixdata_}'=='false'
          Get Value Environment
          Set Global Variable     ${URLTEST}      ${PROTOCOL}://${DOMAIN}
          Set Global Variable     ${API_URLPATH_TEST}     ${APIURLPATH}

      ELSE
          Fail    \nPlease Check '{_fixdata_} Variable' (config-properties.resource) should be 'true' or 'false'.
      END

Get User for login system
   [Arguments]    ${userset}
      Run Keyword If    '${_concurrentmode_}'=='true'     Get data LOGIN USER for concurrent   ${userset}

Get data LOGIN USER for concurrent
   [Arguments]    ${userset}
    Acquire Lock     ${userset}
    Log   This part is critical section
    ${valuesetname}=       Acquire Value Set      ${userset}
    Run Keyword If    '${userset}'=='user1'     SET USER DATA1 for concurrent
    Run Keyword If    '${userset}'=='user2'     SET USER DATA2 for concurrent
    Run Keyword If    '${userset}'=='user3'     SET USER DATA3 for concurrent
    Run Keyword If    '${userset}'=='user4'     SET USER DATA4 for concurrent
    Run Keyword If    '${userset}'=='user5'     SET USER DATA5 for concurrent
    Log   After value set release others can obtain the variable values

#+++++++++++ SET DATA CONCURRENT FOR RUN 5 USERS +++++++++++#
SET USER DATA1 for concurrent
    ${GLOBAL_USER1}=        Get Value From Set     username
    ${GLOBAL_PWD1}=         Get Value From Set     password
    Set Global Variable     ${GLOBAL_USER1}
    Set Global Variable     ${GLOBAL_PWD1}

SET USER DATA2 for concurrent
    ${GLOBAL_USER2}=        Get Value From Set     username
    ${GLOBAL_PWD2}=         Get Value From Set     password
    Set Global Variable     ${GLOBAL_USER2}
    Set Global Variable     ${GLOBAL_PWD2}

SET USER DATA3 for concurrent
    ${GLOBAL_USER3}=       Get Value From Set     username
    ${GLOBAL_PWD3}=        Get Value From Set     password
    Set Global Variable    ${GLOBAL_USER3}
    Set Global Variable    ${GLOBAL_PWD3}

SET USER DATA4 for concurrent
    ${GLOBAL_USER4}=       Get Value From Set     username
    ${GLOBAL_PWD4}=        Get Value From Set     password
    Set Global Variable    ${GLOBAL_USER4}
    Set Global Variable    ${GLOBAL_PWD4}

SET USER DATA5 for concurrent
    ${GLOBAL_USER5}=       Get Value From Set     username
    ${GLOBAL_PWD5}=        Get Value From Set     password
    Set Global Variable    ${GLOBAL_USER5}
    Set Global Variable    ${GLOBAL_PWD5}

#+++++++++++ END:SET DATA CONCURRENT FOR RUN 5 USERS +++++++++++#

Get locator for attribute checkbox field
    [Arguments]   ${locator_field}
      ${checkbox_for_attr}=       Get Attribute         ${locator_field}      value
      Set Global Variable          ${checkbox_for_attr}

Get default value select type
    [Arguments]     ${locator_field}
      @{all_values}=                Get Select Options    ${locator_field}
      ${default_selectedvalue}=     Set Variable          ${all_values}[0][label]
      Set Global Variable            ${default_selectedvalue}

Check Type data field
    [Arguments]   ${locator_field}
      ${TYPE_VAL}=          Get Property           ${locator_field}          type
      Set Suite Variable     ${TYPE_VAL}

#--------------------- Handle Data Table ----------------------#
verify result data table
    [Arguments]      ${locator_tbody}      ${column_index}     ${assertion}      ${expected_data}    ${rowdata}=all     ${ignore_case}=false      ${message_norecord}=${VAR_DEFAULT_NORECORDFOUND}
      
      Sleep   500ms
      ${theadfound}=            Run Keyword And Return Status    Wait For Elements State    ${locator_tbody}/tr[1]/td[1]    visible     timeout=500ms
      IF  '${theadfound}'=='True'
          ${found_data}=        Run Keyword And Return Status    Get Text    ${locator_tbody}/tr[1]/td[1]      inequal       ${message_norecord}
      ELSE
          ${found_data}=        Run Keyword And Return Status    Get Text    ${locator_tbody}/tr[2]/td[1]      inequal       ${message_norecord}
      END

      IF   '${found_data}'=='True' and '${rowdata}'=='all'
           resourcekeywords.Get row entries of Data Table     ${locator_tbody}
      ELSE IF   '${found_data}'=='False'
            Fail    No records found, please check data table. 
            ...     \nIf you want to verify no record found. Use Keyword : 'Verify data table result is No Record Found'
      ELSE
            Set Local Variable    ${GLOBAL_ENTRIES_RESULTOFPAGE}    1
      END

      @{GLOBAL_RETURNDATA_RESULT}=    Create List
      FOR     ${index}    IN RANGE      1         ${GLOBAL_ENTRIES_RESULTOFPAGE}+1
          IF   '${ignore_case}'=='false'
              IF   '${rowdata}'=='all'
                    ${return_val}=      Get Text      ${locator_tbody}/tr[${index}]/td[${column_index}]       ${assertion}         ${expected_data}
                    
              ELSE
                    ${return_val}=      Get Text      ${locator_tbody}/tr[${rowdata}]/td[${column_index}]     ${assertion}         ${expected_data}
                    Log      \nverify result datatable(${column_index}): ${return_val}_${assertion}_${expected_data}    console=True
              END
                Insert Into List    ${GLOBAL_RETURNDATA_RESULT}    ${index}     ${return_val}

          ELSE IF   '${ignore_case}'=='true'
                IF   '${rowdata}'=='all'
                    ${return_val}=      Get Text      ${locator_tbody}/tr[${index}]/td[${column_index}]
                ELSE
                    ${return_val}=      Get Text      ${locator_tbody}/tr[${rowdata}]/td[${column_index}]
                END
                Insert Into List    ${GLOBAL_RETURNDATA_RESULT}    ${index}     ${return_val}

                IF  '${assertion}'=='should be'
                    ${return_val}=        Remove String Using Regexp    ${return_val}       ^[ \t]+|[ \t]+$
                    ${expected_data}=     Remove String Using Regexp    ${expected_data}    ^[ \t]+|[ \t]+$
                    Should Be Equal       ${return_val}       ${expected_data}       ignore_case=True
                    Log       \nverify result datatable(${column_index}): ${return_val}_${assertion}_${expected_data}    console=True
                ELSE IF   '${assertion}'=='contains'
                    Should Contain      ${return_val}       ${expected_data}       ignore_case=True
                    Log       \nverify result datatable(${column_index}): ${return_val}_${assertion}_${expected_data}    console=True
                ELSE
                    Fail    \nPlease check assertion arg. should any 'should be' or 'contains'.
                END
          ELSE
                Fail    \nPlease check ignore case should be any 'true' or 'false'.
          END
      END
      Set Global Variable      @{GLOBAL_RETURNDATA_RESULT}


Get Column of Data Table
    [Arguments]    ${locator_thead}
        
      ${amount_th_row}=       Get Element Count        ${locator_thead}/tr
      ${column_datatable}=    Get Element Count        ${locator_thead}/tr[${amount_th_row}]/th

      Set local Variable     &{col_datatable}      &{EMPTY}
      FOR   ${key}    IN RANGE    ${column_datatable}
              ${index_col}=         Evaluate                 ${key}+1
              ${columnname_val}=    Get Text                 ${locator_thead}/tr[${amount_th_row}]/th[${index_col}]
              ${columnname_val}=    Replace String           ${columnname_val}        \n            ${SPACE}
              ${columnname_val}=    Remove String            ${columnname_val}        ${EMPTY}      ${SPACE}    .     ,     -   /    (    )
              ${columnname_val}=    Convert To Lower Case    ${columnname_val}
            Set To Dictionary     ${col_datatable}     ${columnname_val}=${key}
      END
      Set Global Variable     ${col_datatable}

#--------------------------------------------------------------------------------------------------------------------------------------------------#
#  Get row entries of Data Table   >> Keyword for get row of table >> using locator tbody ex. //*[@id="gmnl-items-list"]/tbody"                    #
#--------------------------------------------------------------------------------------------------------------------------------------------------#
Get row entries of Data Table
    [Arguments]     ${locator_tbody}      ${msg_norecord}=${VAR_DEFAULT_NORECORDFOUND}

      Wait For Elements State    ${locator_tbody}/tr[1]       visible       timeout=3s
      ${IS_NORECORD}=       Run Keyword And Return Status       Get Text      ${locator_tbody}/tr[1]/td[1]       inequal      ${msg_norecord}

      IF  '${IS_NORECORD}'=='True'
            ${GLOBAL_ROWRESULT_DATA_TABLE}=       Get Element Count       ${locator_tbody}/tr
            Set Global Variable     ${GLOBAL_ROWRESULT_DATA_TABLE}

            ${GLOBAL_ENTRIES_RESULTOFPAGE}=       Set Variable If    ${GLOBAL_ROWRESULT_DATA_TABLE} > ${VAR_DEFAULTPAGING}    ${VAR_DEFAULTPAGING}     ${GLOBAL_ROWRESULT_DATA_TABLE}
            Set Global Variable     ${GLOBAL_ENTRIES_RESULTOFPAGE}
      ELSE
            Set Global Variable     ${GLOBAL_ENTRIES_RESULTOFPAGE}          0
            Log    \nCannot get row entries: ${msg_norecord}    console=True
      END


