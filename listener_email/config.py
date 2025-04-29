import os

# condition to send email if 'True' email will be sent
SEND_EMAIL = True

# email smtp (smpt of yahoo, gmail, msn, outlook etc.,)
SMPT = "smtp.mail.yahoo.com"
SMPTPORT = 587
IMAP = "imap.mail.yahoo.com"
IMAPPORT = 993

# email subject
SUBJECT = os.getenv('SUBJECT_EMAIL')

# credentials
FROM = "qualityassurance.nb@yahoo.com"
PASSWORD = "frjatiqnwgseghnb"

# receivers
TO = os.getenv('EMAIL_RECEIVERS')

# Get the values from environment variables
RUN_BROWSER = os.getenv('RUN_BROWSER')
PROTOCOL = os.getenv('PROTOCOL_PROJECT')
DOMAIN = os.getenv('DOMAIN_PROJECT')
URLPATH = os.getenv('URLPATH_PROJECT')

HEADER_NAME = "Summary Result Report"
OTHERINFO = "Browser: "

if RUN_BROWSER is not None:
    OTHERINFO += RUN_BROWSER
else:
    OTHERINFO += "FIXDATA"

OTHERINFO += "<br>Domain: "

if PROTOCOL is not None and DOMAIN is not None and URLPATH is not None:
    OTHERINFO += PROTOCOL + "://" + DOMAIN + "/" + URLPATH
else:
    OTHERINFO += "FIXDATA"

# Zentao API configuration
ZENTAO_ENABLED = os.getenv('ZENTAO_ENABLED', 'False') == 'True'
ZENTAOSID = os.getenv('ZENTAOSID', '')

# รับค่า SUITEID และจัดการให้รองรับหลายค่า
raw_suite_id = os.getenv('SUITEID', '')
# ถ้ามีเครื่องหมาย , แสดงว่ามีหลาย SUITEID
if ',' in raw_suite_id:
    SUITEID = raw_suite_id  # เก็บเป็นสตริงที่คั่นด้วยเครื่องหมายคอมม่า
else:
    SUITEID = raw_suite_id  # เก็บเป็นสตริงค่าเดียว

FALLBACK_REC_TOTAL = int(os.getenv('FALLBACK_REC_TOTAL', 0))

# แสดงค่า config ที่เกี่ยวกับ Zentao
if ZENTAO_ENABLED:
    print("Zentao Configuration:")
    print(f"  ZENTAO_ENABLED: {ZENTAO_ENABLED}")
    print(f"  ZENTAOSID: {'*****' + ZENTAOSID[-4:] if len(ZENTAOSID) > 4 else '*****'}")
    print(f"  SUITEID: {SUITEID}")
    print(f"  FALLBACK_REC_TOTAL: {FALLBACK_REC_TOTAL}")