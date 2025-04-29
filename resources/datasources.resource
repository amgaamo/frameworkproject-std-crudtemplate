*** Settings ***
Resource    commonkeywords.resource

*** Variable ***
####### CSV PATH #######
${CSVPATH_LOGINDATA}                 ${CURDIR}${/}datatest${/}login_data.csv

*** Keywords ***
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

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

Import DataSource USER LOGIN
      Import datasource file    ${CSVPATH_LOGINDATA}
      Set Global Variable       ${login_col}      ${value_col}
      Set Global Variable       ${DS_LOGIN}       ${datasource_val}
