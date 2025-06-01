*** Variables ***
${IBOX_LOGIN_URL}                          https://demoinvoicechain.netbay.co.th/ibox-front-2/#/login
${IBOX_CONFIG_MAIN_MENU}                   //*[text()='ตั้งค่า']
${IBOX_USERMGMT_MAIN_MENU}                 //*[text()=' จัดการผู้ใช้งาน ']
${IBOX_LOCATOR_SEARCH_COMPANY_NAME}        //*[@id="s-text-styled-box"]
${IBOX_LOCATOR_SEARCH_COMPANY_NAME_BTN}    //*[@id="s-text-btn-styled-box"]
${IBOX_LOCATOR_VIEW_COMPANY_NAME}          (//*[text()='ดูข้อมูล'])[1]
${IBOX_SEARCH_COMPANY_NAME_VALUE}          Triple T Internet Company Limited

${ONE4ALL_LOGIN_URL}            https://10.6.208.81/one-for-all/#/one-for-all-api/auth/login
${ONE4ALL_CONFIG_MAIN_MENU}     //*[text()='การตั้งค่า']
${ONE4ALL_CONFIG_SUBMENU}       //*[text()='การจัดการเมนู']

${PARTY_LOGIN_URL}              https://10.6.220.100/party-qa/officer/login
${PARTY_CONFIG_MAIN_MENU}       //*[text()='จัดการกลุ่มและสิทธิการใช้งาน']
${PARTY_CONFIG_SUBMENU}         //*[text()='User back office']