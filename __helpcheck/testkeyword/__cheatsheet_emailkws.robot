*** Settings ***
Resource    ../../resources/services/service-tempemail.resource

*** Test Cases ***
Test Create New Temp Email Account and Login
    service-tempemail.Create New Temp Email Account    tempxxx_01    Robot@123
    service-tempemail.Login Temp Email Account         tempxxx_01    Robot@123
    Log    tempxxx_01@${GLOBAL_DOMAIN_TEMPEMAIL}       console=True

Test Get Content Message Temp Email Message
    [Tags]    getcontent
    service-tempemail.Get Lastest email domail
    Get Email Content Latest Message from Temp Email Account    tempxxx_01    Robot@123