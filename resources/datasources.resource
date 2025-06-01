*** Settings ***
Resource    commonkeywords.resource

*** Variable ***
#++++++++++++++++++++++++++++#
#          CSV PATH          #               
#++++++++++++++++++++++++++++#

${CSVPATH_LOGINDATA}                 ${CURDIR}${/}datatest${/}login_data.csv



#++++++++++++++++++++++++++++#
#          YAML PATH         #               
#++++++++++++++++++++++++++++#
${YAMLPATH_ANT_DESIGN_DATATEST}      ${CURDIR}${/}datatest${/}example${/}datatest_ant_menudata.yaml
${YAMLPATH_BACKOFFICE_USER}          ${CURDIR}${/}datatest${/}example${/}datatest_backoffice_user.yaml
${YAMLPATH_USER_MANAGEMENT}          ${CURDIR}${/}datatest${/}example${/}datatest_user_management.yaml
${YAMLPATH_REGISTRATION}             ${CURDIR}${/}datatest${/}example${/}datatest_registration.yaml

*** Keywords ***
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# Import DataSource - For CSV File
# This keyword is used to import a CSV file as a dictionary.
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

Import datasource file
    [Arguments]     ${pathfile}
      # ${htable}=             Read Table From Csv    path=${pathfile}   header=${FALSE}     columns=None        delimiters=,     encoding=UTF-8
      # ${header_row}=         Pop Table Row     ${htable}         as_list=${TRUE}
      
      ${file_content}=    Get File    ${pathfile}
      ${lines}=    Split String    ${file_content}    \n
      ${header_row}=    Split String    ${lines[0]}    ,
      
      ${name_key_col}=       Get From List     ${header_row}     0
      Remove Values From List         ${header_row}     ${name_key_col}
      ${length_col}=    Get Length    ${header_row}

      Set local Variable     &{value_col}     &{EMPTY}
      FOR   ${key}    IN RANGE    ${length_col}
            Set To Dictionary     ${value_col}    ${header_row}[${key}]=${key}
            ${key}=   Evaluate   ${key}+1
      END

      ${datasource_val}=     read csv as dictionary    ${pathfile}     ${name_key_col}     ${header_row}     ,

      Set Suite Variable    ${value_col}
      Set Suite Variable    ${datasource_val}

#++++++++++++++++++++++++++++++++++++++++++++++#
# Example of Import DataSource - For CSV File  #
#++++++++++++++++++++++++++++++++++++++++++++++#
Import DataSource USER LOGIN
      Import datasource file    ${CSVPATH_LOGINDATA}
      Set Global Variable       ${login_col}      ${value_col}
      Set Global Variable       ${DS_LOGIN}       ${datasource_val}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# Import DataSource - For yaml File
# This keyword is used to import a yaml file as a dictionary.
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

Load YAML Data
    [Arguments]    ${yaml_file}
    [Documentation]    โหลดข้อมูลจากไฟล์ YAML และเก็บไว้ในตัวแปรกลาง
    ${yaml_str}=    Get File    ${yaml_file}
    ${yaml_data}=    Evaluate    yaml.safe_load('''${yaml_str}''')    yaml
    Set Suite Variable    ${YAML_DATA}    ${yaml_data}
    Log    Load Data From YAML File Success : ${yaml_file}

Update Fields From YAML
    [Arguments]       ${yaml_file}      ${scenario_key}      @{field_sets}
    [Documentation]    
    ...    อัปเดตฟิลด์ที่ระบุในตัวแปร field_sets โดยใช้ข้อมูลจาก YAML
    ...    เพิ่ม random data ต่อท้ายค่าตามรูปแบบที่กำหนด {random:type:length}  (type = digits, letters, alphanumeric, lowercase, uppercase)
    ...    example: {random:digits:5}, {random:letters:4}, {random:alphanumeric:2}, {random:lowercase:3}, {random:uppercase:5}
    
    Load YAML Data      ${yaml_file}
 
    # Check if scenario exists in YAML data
    Dictionary Should Contain Key    ${YAML_DATA}    ${scenario_key}    
    ...    msg=Scenario '${scenario_key}' not found in YAML file

    # Get scenario data 
    ${scenario_data}=    Get From Dictionary    ${YAML_DATA}    ${scenario_key}
    
    # Process each dictionary in the field_sets list
    ${field_count}=    Get Length    ${field_sets}
    FOR    ${i}    IN RANGE    ${field_count}
        ${field_set}=    Set Variable    ${field_sets}[${i}]
        
        # Ensure field_set is a dictionary
        ${is_dict}=    Evaluate    isinstance($field_set, dict)
        IF    not ${is_dict}
            Log    Warning: Item at index ${i} in field_sets is not a dictionary. Skipping.    WARN
            CONTINUE
        END
        
        # Get mapping field name
        ${mapping_field}=    Get From Dictionary    ${field_set}    value
        
        # Check if field exists in YAML scenario
        ${field_exists}=    Run Keyword And Return Status    
        ...    Dictionary Should Contain Key    ${scenario_data}    ${mapping_field}
        
        # If the field exists in YAML, update field set values
        IF    ${field_exists}
            ${yaml_field_data}=    Get From Dictionary    ${scenario_data}    ${mapping_field}
            
            # Get all available keys in the yaml field data
            ${yaml_keys}=    Get Dictionary Keys    ${yaml_field_data}
            
            # Loop through all keys in yaml field data and update matching properties
            FOR    ${key}    IN    @{yaml_keys}
                ${yaml_value}=    Get From Dictionary    ${yaml_field_data}    ${key}
                
                # Check for random data suffix configuration
                ${has_random_suffix}=    Run Keyword And Return Status    
                ...    Should Match Regexp    ${yaml_value}    .*\\{random:\\w+:\\d+\\}.*
                
                # Process random data suffix if needed
                IF    ${has_random_suffix}
                    # Process each match of random pattern
                    @{matches}=    Get Regexp Matches    ${yaml_value}    \\{random:(\\w+):(\\d+)\\}    1    2
                    ${result}=    Set Variable    ${yaml_value}
                    
                    FOR    ${match}    IN    @{matches}
                        ${type}=    Set Variable    ${match}[0]
                        ${length}=    Set Variable    ${match}[1]
                        ${length}=    Convert To Integer    ${length}
                        
                        # Generate random string based on type
                        IF    '${type}' == 'digits'
                            ${random_str}=    Generate Random String    ${length}    [NUMBERS]
                        ELSE IF    '${type}' == 'letters'
                            ${random_str}=    Generate Random String    ${length}    [LETTERS]
                        ELSE IF    '${type}' == 'alphanumeric'
                            ${random_str}=    Generate Random String    ${length}    [LETTERS][NUMBERS]
                        ELSE IF    '${type}' == 'lowercase'
                            ${random_str}=    Generate Random String    ${length}    [LOWER]
                        ELSE IF    '${type}' == 'uppercase'
                            ${random_str}=    Generate Random String    ${length}    [UPPER]
                        ELSE
                            ${random_str}=    Generate Random String    ${length}    [LETTERS][NUMBERS]
                        END
                        
                        # Replace the pattern with random string
                        ${pattern}=    Set Variable    \\{random:${type}:${length}\\}
                        ${result}=    Replace String Using Regexp    ${result}    ${pattern}    ${random_str}
                    END
                    
                    # Update yaml_value with processed result
                    ${yaml_value}=    Set Variable    ${result}
                END
                
                # Set the value in the field_set
                Set To Dictionary    ${field_set}    ${key}=${yaml_value}
                # Update the field_set in the original list
                Set List Value    ${field_sets}    ${i}    ${field_set}
                Log    Updated ${mapping_field}.${key} to: ${yaml_value}
            END
        END
    END
    
    Log    Field sets updated successfully for scenario: ${scenario_key}
    Set Global Variable    @{GLOBAL_UPDATE_FIELD_SETS}     @{field_sets} 
    Log Many    @{GLOBAL_UPDATE_FIELD_SETS}