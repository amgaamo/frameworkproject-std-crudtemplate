*** Settings ***
Resource    ../../resources/services/service-tempemail.resource

*** Test Cases ***
Test Create New Temp Email Account and Login
    service-tempemail.Get Lastest email domail
    service-tempemail.Create New Temp Email Account    testxaccc02    Robot@123
    service-tempemail.Login Temp Email Account         testxaccc02    Robot@123
    Log To Console    testxaccc02@${GLOBAL_DOMAIN_TEMPEMAIL}

Test Get Content Message Temp Email Message
    [Tags]    getcontent
    service-tempemail.Get Lastest email domail
    Get Email Content Latest Message from Temp Email Account    testxaccc02    Robot@123