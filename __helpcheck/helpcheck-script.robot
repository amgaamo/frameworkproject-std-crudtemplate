*** Settings ***
Resource          ../resources/commonkeywords.resource
Resource          ../resources/services/utility-services.resource

Suite Setup       datasources.Import DataSource USER LOGIN
Test Setup        commonkeywords.Initialize System and Go to Login Page
Test Teardown     Release user lock and close all browser


*** Test Cases ***
Helpcheck Login system
      commonkeywords.Fill in Username Field       ${DS_LOGIN['superadmin'][${login_col.username}]}
      commonkeywords.Fill in Password Field       ${DS_LOGIN['superadmin'][${login_col.password}]}
      commonkeywords.Click Login Button
      commonkeywords.Ignore warning Login
      commonkeywords.Verify Welcome page
      commonkeywords.Logout System
      Log To Console      \nhelpcheck status PASS.

Helpcheck Call API service
      Log To Console      \n+++ helpcheck API Request by RequestLib +++
      main-services.Request Service RequestLib Get Session Data    ${DS_LOGIN['superadmin'][${login_col.username}]}      ${DS_LOGIN['superadmin'][${login_col.password}]}
      Should Be Equal    ${GLOBAL_APIUSERNAME}          ${DS_LOGIN['superadmin'][${login_col.username}]}
      Request Service Logout System (RequestLib)        ${DS_LOGIN['superadmin'][${login_col.username}]}      ${DS_LOGIN['superadmin'][${login_col.password}]}
      Log To Console      \nhelpcheck API Request by RequestLib status PASS.


Helpcheck Go to menu
      commonkeywords.Login System                   ${DS_LOGIN['superadmin'][${login_col.username}]}      ${DS_LOGIN['superadmin'][${login_col.password}]}
      commonkeywords.Go to SUBMENU name             ${mainmenu}[configuration]       ${submenu}[usermgt]
      commonkeywords.Verify Page Name is correct    ${menuname}[usermgt]
      Log To Console      \nhelpcheck status PASS.
