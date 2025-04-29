## How to fork script template

1. Click 'Fork' button
2. Change Project name and choose Project URL
3. Click Fork Project button

#### Git upstream: Keep up-to-date

**1.add upstream remote**
	
	git remote add upstream https://idemo.netbay.co.th/gitlab/QA/projectframework-robot/frameworkproject-std.git

**2.git fetch upstream to fetch repo frameworkproject-std**
	
	git fetch upstream

**3.Checkout branch to merge upstream**
	
	git checkout master
	git merge upstream/master

## How to run script or use Images

#### Install Library

**1) robotframework-browser**

	Following step to install lib https://robotframework-browser.org/#installation

**2) Other Lib**

	pip install robotframework-csvlib==1.0.1
	pip install robotframework-jsonlibrary
	pip install robotframework-imaplibrary2==0.4.1
	pip install pymysql
	pip install -U robotframework-pabot
	pip install robotframework-databaselibrary==1.2.4
	pip install robotframework-requests

------------

#### Set Environment

| Environment Name | Description |
| ------ | ------ |
| RUN_BROWSER | ระบุ Browser โดยระบุ 2 Browser คือ chromium หรือ firefox |
| PROTOCOL_PROJECT | Protocol ของระบบ ระบุ http หรือ https |
| DOMAIN_PROJECT | Domain ของระบบ โดยระบุเป็น domain หรือ ip|
| URLPATH_PROJECT | Url Path ของระบบ |
| API_URLPATH_PROJECT | Url Path สำหรับการยิง API |
| EMAIL_RECEIVERS | ระบุ email ของผู้รับผลการทดสอบ |

**ตรวจสอบต้องมี superadmin ที่ Login เข้าระบบก่อนรันเสมอ**
โดยระบุ username/password ที่เป็น superadmin ได้ที่
> **resources >> datatest >> login_data.csv**

**How to run script robot**
> robot -d output --listener listener_email/EmailListener.py -V listener_email/config.py testsuite

#### Using Images

1. Pull Image ตัวล่าสุด
2. ดาวน์โหลด env.list ไปวางไว้ที่เดียวกับ images
3. ระบุข้อมูล env.list ให้เรียบร้อยตามไซต์ที่ทดสอบ
4. รันโดยใช้คำสั่ง

> docker run --rm --env-file env.list {{imagename}} robot -d output --listener listener_email/EmailListener.py -V listener_email/config.py testsuite

จะเป็นการรันสคริปต์ทั้งหมดที่อยู่ใน testsuite หากต้องการรันตามฟังก์ชันงานสามารถเพิ่มโฟลเดอร์หลัง testsuite ดังต่อไปนี้

    testsuite/{{FOLDER_FUNCTION_TEST}}
ใส่โฟลเดอร์ฟังก์ชันงานที่ต้องการรัน กรณีที่ต้องการรันบางฟังก์ชันงาน
