# -*- coding: utf-8 -*-
import os
import math
import datetime
import platform
import time
import sys
import shutil

from zipfile import ZipFile
from os import path
from shutil import make_archive
from robot.libraries.BuiltIn import BuiltIn
from RPA.Email.ImapSmtp import ImapSmtp

# นำเข้าฟังก์ชัน request_zentao_api จากไฟล์ request_zentao_api.py
from request_zentao_api import request_zentao_api

class EmailListener:

    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self):
        self.total_tests = 0
        self.passed_tests = 0
        self.failed_tests = 0
        self.PRE_RUNNER = 0
        self.start_time = datetime.datetime.now().time().strftime('%H:%M:%S')
        
        # สำหรับเก็บค่า manual test cases จาก Zentao
        self.manual_test_cases = 0
        # สำหรับเก็บรายละเอียด suite IDs
        self.suite_details = []
        # เพิ่มการกำหนดค่าเริ่มต้นสำหรับ test_count
        self.test_count = 0

    def start_suite(self, name, attrs):

        # Fetch email details only once
        if self.PRE_RUNNER == 0:
            self.SEND_EMAIL = BuiltIn().get_variable_value("${SEND_EMAIL}")
            self.SMPT = BuiltIn().get_variable_value("${SMPT}")
            self.SMPTPORT = BuiltIn().get_variable_value("${SMPTPORT}")
            self.IMAP = BuiltIn().get_variable_value("${IMAP}")
            self.IMAPPORT = BuiltIn().get_variable_value("${IMAPPORT}")
            self.SUBJECT = BuiltIn().get_variable_value("${SUBJECT}")
            self.FROM = BuiltIn().get_variable_value("${FROM}")
            self.PASSWORD = BuiltIn().get_variable_value("${PASSWORD}")
            self.TO = BuiltIn().get_variable_value("${TO}")
            self.HEADER_NAME = BuiltIn().get_variable_value("${HEADER_NAME}")
            self.OTHERINFO = BuiltIn().get_variable_value("${OTHERINFO}")
            
            # ดึงค่า config สำหรับ Zentao
            # แก้ไขการดึงค่า ZENTAO_ENABLED ให้ได้ค่า boolean โดยตรง
            zentao_enabled_str = BuiltIn().get_variable_value("${ZENTAO_ENABLED}", "False")
            if isinstance(zentao_enabled_str, str):
                self.ZENTAO_ENABLED = (zentao_enabled_str.lower() == "true")
            else:
                self.ZENTAO_ENABLED = bool(zentao_enabled_str)

            self.ZENTAOSID = BuiltIn().get_variable_value("${ZENTAOSID}", "")
            self.SUITEID = BuiltIn().get_variable_value("${SUITEID}", "")
            
            # แปลงค่า FALLBACK_REC_TOTAL เป็นตัวเลข
            fallback_str = BuiltIn().get_variable_value("${FALLBACK_REC_TOTAL}", "0")
            try:
                self.FALLBACK_REC_TOTAL = int(fallback_str)
            except (ValueError, TypeError):
                self.FALLBACK_REC_TOTAL = 0
            
            self.PRE_RUNNER = 1

            self.date_now = datetime.datetime.now().strftime("%Y-%m-%d")
            
            print("Zentao API Enabled:", self.ZENTAO_ENABLED)
            # เรียกใช้ Zentao API เฉพาะเมื่อ ZENTAO_ENABLED=True เท่านั้น
            if self.ZENTAO_ENABLED is True:
                print("กำลังเตรียมเรียกใช้ Zentao API...")
                zentao_config = {
                    'zentao': {
                        'enabled': self.ZENTAO_ENABLED,
                        'zentaosid': self.ZENTAOSID,
                        'suiteID': self.SUITEID,
                        'fallbackRecTotal': self.FALLBACK_REC_TOTAL
                    }
                }
                
                zentao_result = request_zentao_api(zentao_config)
                
                if zentao_result['success']:
                    self.manual_test_cases = zentao_result['recTotal']
                    if 'details' in zentao_result:
                        self.suite_details = zentao_result['details']
                        # แสดงรายละเอียดของแต่ละ suite
                        print("\nรายละเอียดจำนวน Test Cases แยกตาม suiteID:")
                        for detail in self.suite_details:
                            print(f"  suiteID {detail['suiteID']}: {detail['count']} test cases")
                    
                    print(f"\nจำนวน Manual Test Cases รวมทั้งหมด: {self.manual_test_cases}")
                else:
                    print(f"ไม่สามารถดึงข้อมูลจาก Zentao: {zentao_result.get('message', 'Unknown error')}")
                    self.manual_test_cases = self.FALLBACK_REC_TOTAL
                    print(f"ใช้ค่า Fallback แทน: {self.manual_test_cases}")
            else:
                print("ไม่ได้เปิดใช้งาน Zentao API")
                self.manual_test_cases = None
                print("ไม่มีการดึงข้อมูล Manual Test Cases")

        # ตรวจสอบว่า attrs มี key 'tests' หรือไม่
        if attrs and 'tests' in attrs:
            self.test_count = len(attrs['tests'])
        else:
            self.test_count = 0

    def end_test(self, name, attrs):
        # ตรวจสอบว่า test_count มีค่าหรือไม่ก่อนใช้งาน
        if hasattr(self, 'test_count') and self.test_count != 0:
            self.total_tests += 1

        if attrs['status'] == 'PASS':
            self.passed_tests += 1
        else:
            self.failed_tests += 1

    def close(self):
        self.end_time = datetime.datetime.now().time().strftime('%H:%M:%S')
        self.total_time = (datetime.datetime.strptime(self.end_time,'%H:%M:%S') - datetime.datetime.strptime(self.start_time,'%H:%M:%S'))
        
        # คำนวณ pass percentage
        pass_percentage = 0
        if self.total_tests > 0:
            pass_percentage = math.floor(self.passed_tests * 100.0 / self.total_tests)
        
        # ค่าที่จะแสดงใน email
        manual_display = "-"
        coverage_display = "-"
        
        # สร้างข้อความแสดงรายละเอียด suiteIDs (ถ้ามี)
        suite_details_str = ""
        if self.suite_details:
            suite_details_str = "<br><br>รายละเอียด suiteIDs:<br>"
            for detail in self.suite_details:
                suite_details_str += f"suiteID {detail['suiteID']}: {detail['count']} test cases<br>"
        
        # คำนวณและแสดงค่า manual test cases และ coverage เฉพาะเมื่อ ZENTAO_ENABLED=True
        if self.ZENTAO_ENABLED and self.manual_test_cases is not None and self.manual_test_cases > 0:
            coverage_percentage = math.floor(self.total_tests * 100.0 / self.manual_test_cases)
            manual_display = str(self.manual_test_cases)
            coverage_display = str(coverage_percentage)

        # เพิ่มรายละเอียด suiteIDs เข้าไปใน otherinfo
        other_info_with_details = self.OTHERINFO or ""
        if suite_details_str:
            other_info_with_details += suite_details_str

        send_email(
            self.SEND_EMAIL, 
            self.SUBJECT, 
            self.SMPT,
            self.SMPTPORT, 
            self.FROM, 
            self.PASSWORD, 
            self.TO,
            self.total_tests, 
            self.passed_tests, 
            self.failed_tests, 
            pass_percentage,
            self.date_now, 
            self.total_time, 
            self.HEADER_NAME, 
            other_info_with_details,
            manual_display,
            coverage_display
        )

        if self.failed_tests != 0:
            print("*** TESTS FAILED ***")
            print(" >>> Email Sent successfully")
            sys.exit(1)
        else:
            print("*** TESTS PASSED ***")
            print(" >>> Email Sent successfully")

def send_email(send_email, subject, smtp, smtpport, from_user, pwd, to, total, passed, failed, 
              percentage, exe_date, elapsed_time, header_name, otherinfo, manual_display, coverage_display):
    if send_email:
        email_content = """
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
        <title>Automation Status</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0 " />
            <style>
                .rf-box {
                    max-width: 60%%;
                    margin: auto;
                    padding: 30px;
                    border: 3px solid #eee;
                    box-shadow: 0 0 10px rgba(0, 0, 0, .15);
                    font-size: 16px;
                    line-height: 28px;
                    font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
                    color: #555;
                }

                .rf-box table {
                    width: 100%%;
                    line-height: inherit;
                    text-align: left;
                }

                .rf-box table td {
                    padding: 5px;
                    vertical-align: top;
                    width: 50%%;
                    text-align: center;
                }

                .rf-box table tr.heading td {
                    background: #eee;
                    border-bottom: 1px solid #ddd;
                    font-weight: bold;
                    text-align: left;
                }

                .rf-box table tr.item td {
                    border-bottom: 1px solid #eee;
                }
            </style>
        </head>
        <body>

            <div class="rf-box">
                <table cellpadding="0" cellspacing="0">
                    <tr class="top">
                        <td colspan="2">
                            <table>
                                <tr>
                                    <td></td>
                                    <td style="text-align:middle">
										<h1>%s</h1>
									</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>

                <p style="padding-left:20px">
                    Hi Team,<br>
                    Following are the last build execution result. Please refer attachment for more info
                </p>

                <table style="width:80%%;padding-left:20px">
                    <tr class="heading">
                        <td>Test Status:</td>
                        <td></td>
                    </tr>
                    <tr class="item">
                        <td>Total Automation Tests</td>
                        <td>%s</td>
                    </tr>
                    <tr class="item">
                        <td>Pass</td>
                        <td style="color:green">%s</td>
                    </tr>
                    <tr class="item">
                        <td>Fail</td>
                        <td style="color:red">%s</td>
                    </tr>
                    <tr class="item">
                        <td>Pass Percentage (%%)</td>
                        <td>%s</td>
                    </tr>
                    <tr class="item">
                        <td>Manual Test Cases</td>
                        <td>%s</td>
                    </tr>
                    <tr class="item">
                        <td>Test Coverage (%%)</td>
                        <td>%s</td>
                    </tr>
                </table>

                <br>

                <table style="width:80%%;padding-left:20px">
                    <tr class="heading">
                        <td>Other Info:</td>
                        <td></td>
                    </tr>
                    <tr class="item">
                        <td>Executed Date</td>
                        <td>%s</td>
                    </tr>
                    <tr class="item">
                        <td>Machine</td>
                        <td>%s</td>
                    </tr>
                    <tr class="item">
                        <td>OS</td>
                        <td>%s</td>
                    </tr>
                    <tr class="item">
                        <td>Duration</td>
                        <td>%s</td>
                    </tr>
                    <tr class="item">
                        <td>Other Info.</td>
                        <td>%s</td>
                    </tr>
                </table>
            </div>
        </body>
        </html>
        """ % (header_name, total, passed, failed, percentage, manual_display, coverage_display, 
              exe_date, platform.uname()[1], platform.uname()[0], elapsed_time, otherinfo)

        # ตรวจสอบว่าโฟลเดอร์ output มีอยู่หรือไม่
        if not os.path.exists('output'):
            print("Warning: Directory 'output' does not exist. Creating it...")
            os.makedirs('output')

        os.chdir('output')
        
        # สร้างโฟลเดอร์ report_test ถ้ายังไม่มี
        if not os.path.exists('report_test'):
            os.makedirs('report_test')
        
        # ตรวจสอบว่าไฟล์ log.html และ report.html มีอยู่หรือไม่
        if os.path.exists('log.html'):
            shutil.copy2('log.html', 'report_test')
        else:
            print("Warning: 'log.html' not found")
            
        if os.path.exists('report.html'):
            shutil.copy2('report.html', 'report_test')
        else:
            print("Warning: 'report.html' not found")
        
        # สร้างโฟลเดอร์สำหรับเก็บ screenshot
        screenshot_dir = 'report_test/browser/screenshot'
        if not os.path.exists(screenshot_dir):
            os.makedirs(screenshot_dir)
            
        if os.path.exists('browser/screenshot'):
            for file_name in os.listdir('browser/screenshot'):
                source = os.path.join('browser/screenshot', file_name)
                destination = os.path.join(screenshot_dir, file_name)
                if os.path.isfile(source):
                    shutil.copy2(source, destination)

        # สร้างไฟล์ zip
        shutil.make_archive("report", "zip", "report_test")

        # ตรวจสอบว่าไฟล์ report.zip มีอยู่หรือไม่
        if not os.path.exists('report.zip'):
            print("Warning: Failed to create 'report.zip'")
            
        #file to be sent
        filename = "report.zip"
        
        try:
            mail = ImapSmtp()
            mail.authorize(account=from_user, password=pwd, smtp_server=smtp, smtp_port=smtpport)
            mail.send_message(
                    sender=from_user,
                    recipients=to,
                    subject=subject,
                    body=email_content,
                    attachments=filename,
                    html=True,
            )
        except Exception as e:
            print(f"Error sending email: {str(e)}")

    else:
        sys.exit(1)