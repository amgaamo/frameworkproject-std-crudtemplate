# -*- coding: utf-8 -*-
# request_zentao_api.py
# โมดูลสำหรับดึงข้อมูลจาก Zentao API

import requests
import json
import re
import urllib3
from typing import Dict, Any, Union, Optional, List

# ปิดการแจ้งเตือนเกี่ยวกับ SSL certificate
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def parse_suite_ids(suite_ids_raw):
    """
    แปลงค่า suiteID จากรูปแบบต่างๆ เป็นรายการของตัวเลข
    
    Args:
        suite_ids_raw: ค่า suiteID ที่ได้รับจาก config
        
    Returns:
        List: รายการของ suiteID ที่เป็นตัวเลข
    """
    if not suite_ids_raw:
        return []
    
    # กรณีเป็นรายการอยู่แล้ว
    if isinstance(suite_ids_raw, list):
        return [int(sid) for sid in suite_ids_raw if str(sid).strip()]
    
    # กรณีเป็นสตริงที่คั่นด้วยเครื่องหมาย comma
    if isinstance(suite_ids_raw, str):
        return [int(sid) for sid in suite_ids_raw.split(',') if sid.strip() and sid.strip().isdigit()]
    
    # กรณีเป็นตัวเลขอยู่แล้ว
    if isinstance(suite_ids_raw, (int, float)):
        return [int(suite_ids_raw)]
    
    return []


def extract_rec_total(data):
    """
    ดึงค่า recTotal จากข้อมูลที่ได้รับจาก API
    
    Args:
        data: ข้อมูลที่ได้รับจาก API
        
    Returns:
        int: ค่า recTotal ที่พบ หรือ 0 ถ้าไม่พบ
    """
    rec_total = 0
    
    try:
        # กรณีข้อมูลเป็น dictionary
        if isinstance(data, dict):
            # 1. ตรวจสอบกรณีที่มี data เป็น string ที่เป็น JSON string อีกทีหนึ่ง
            if data.get('data') and isinstance(data['data'], str):
                try:
                    parsed_inner_data = json.loads(data['data'])
                    
                    # ตรวจสอบ pager ในข้อมูลที่แปลงแล้ว
                    if parsed_inner_data.get('pager') and 'recTotal' in parsed_inner_data['pager']:
                        return int(parsed_inner_data['pager']['recTotal'])
                    # ตรวจสอบ caseCount
                    elif parsed_inner_data.get('caseCount'):
                        return int(parsed_inner_data['caseCount'])
                    # ตรวจสอบความยาวของลิสต์ cases
                    elif parsed_inner_data.get('cases') and isinstance(parsed_inner_data['cases'], list):
                        return len(parsed_inner_data['cases'])
                except:
                    # ข้ามไปตรวจสอบวิธีอื่น
                    pass
            
            # 2. ตรวจสอบ pager โดยตรง
            if data.get('pager') and 'recTotal' in data['pager']:
                return int(data['pager']['recTotal'])
            
            # 3. ตรวจสอบข้อมูลใน data (ถ้ามี)
            if data.get('data') and isinstance(data['data'], dict):
                # ตรวจสอบ pager ใน data
                if data['data'].get('pager') and 'recTotal' in data['data']['pager']:
                    return int(data['data']['pager']['recTotal'])
                # ตรวจสอบ caseCount
                elif data['data'].get('caseCount'):
                    return int(data['data']['caseCount'])
                # ตรวจสอบความยาวของลิสต์ cases
                elif data['data'].get('cases') and isinstance(data['data']['cases'], list):
                    return len(data['data']['cases'])
        
        # กรณีข้อมูลเป็น string
        elif isinstance(data, str):
            try:
                # พยายามแปลงเป็น JSON ก่อน
                parsed_data = json.loads(data)
                return extract_rec_total(parsed_data)  # เรียกฟังก์ชันเดิมซ้ำเพื่อตรวจสอบ
            except:
                # ใช้ regex ค้นหาค่า recTotal โดยตรง
                patterns = [
                    r'"pager"\s*:\s*{\s*"recTotal"\s*:\s*(\d+)',
                    r'"recTotal"\s*:\s*(\d+)',
                    r'"pager"\s*:\s*{[^}]*"recTotal"\s*:\s*(\d+)',
                    r'recTotal[\'"]?\s*:\s*(\d+)'
                ]
                
                for pattern in patterns:
                    match = re.search(pattern, data)
                    if match and match.group(1):
                        return int(match.group(1))
    
    except Exception as error:
        print(f'เกิดข้อผิดพลาดในการดึงค่า recTotal: {str(error)}')
    
    return rec_total  # ถ้าไม่พบค่า recTotal ให้คืนค่า 0


def request_zentao_api(config):
    """
    ดึงข้อมูลจำนวน test cases จาก Zentao API
    
    Args:
        config: ค่าคอนฟิกจากไฟล์คอนฟิก
        
    Returns:
        Dict: ข้อมูลที่ดึงได้จาก API
    """
    print("\n>> เริ่มต้นกระบวนการดึงข้อมูลจาก Zentao API")
    try:
        # ตรวจสอบว่ามีการตั้งค่า zentao หรือไม่
        if 'zentao' not in config or not config.get('zentao', {}).get('enabled', False):
            print('Zentao integration ไม่ได้เปิดใช้งาน')
            return {
                'success': False,
                'recTotal': 0,
                'message': 'Zentao integration ไม่ได้เปิดใช้งาน'
            }
        
        # ดึงค่า configuration
        zentao_config = config.get('zentao', {})
        zentaosid = zentao_config.get('zentaosid')
        suite_ids_raw = zentao_config.get('suiteID')
        fallback_rec_total = int(zentao_config.get('fallbackRecTotal', 0))
        
        # แปลง suiteID เป็นรายการ (list) ทุกกรณี
        suite_ids = parse_suite_ids(suite_ids_raw)
        
        if not zentaosid or not suite_ids:
            print('ไม่พบค่า zentaosid หรือ suiteID')
            return {
                'success': False,
                'recTotal': fallback_rec_total,
                'message': 'ไม่พบค่า zentaosid หรือ suiteID'
            }
        
        print('กำลังดึงข้อมูลจำนวน manual test cases จาก Zentao...')
        print('กำลังดึงข้อมูลจาก Zentao API...')
        print(f'กำลังดึงข้อมูลจาก suiteID: {", ".join(str(sid) for sid in suite_ids)}')
        
        # กำหนดตัวเลือกสำหรับ requests
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'application/json, text/plain, */*',
            'Accept-Language': 'th,en-US;q=0.9,en;q=0.8',
            'Connection': 'keep-alive',
            'Referer': 'https://zentao.netbay.co.th/zentaoalm/www/',
            'Cache-Control': 'no-cache',
            'Cookie': f'zentaosid={zentaosid}'
        }
        
        # สร้างรายการผลลัพธ์สำหรับแต่ละ suiteID
        results = []
        details = []
        
        # วนลูปเรียก API สำหรับแต่ละ suiteID
        for suite_id in suite_ids:
            try:
                # กำหนด URL
                suite_url = f'https://zentao.netbay.co.th/zentaoalm/www/index.php?m=testsuite&f=view&t=json&suiteID={suite_id}'
                
                # เรียก API
                response = requests.get(suite_url, headers=headers, verify=False, timeout=30)
                
                if response.status_code != 200:
                    print(f'เรียก API ไม่สำเร็จสำหรับ suiteID {suite_id}: {response.status_code}')
                    results.append(0)
                    details.append({'suiteID': suite_id, 'count': 0})
                    continue
                
                # ดึงค่า recTotal
                rec_total = extract_rec_total(response.text)
                
                # แปลงให้เป็นตัวเลขทุกกรณี
                rec_total = int(rec_total) if rec_total else 0
                
                print(f'จำนวน Manual Test Cases สำหรับ suiteID {suite_id}: {rec_total}')
                
                results.append(rec_total)
                details.append({'suiteID': suite_id, 'count': rec_total})
                
            except Exception as e:
                print(f'เกิดข้อผิดพลาดในการดึงข้อมูลจาก suiteID {suite_id}: {str(e)}')
                results.append(0)
                details.append({'suiteID': suite_id, 'count': 0})
        
        # คำนวณผลรวมของ recTotal จากทุก suiteID
        total_rec_count = sum(results)
        
        print(f'จำนวน Manual Test Cases รวมทั้งหมด: {total_rec_count}')
        
        # ถ้าไม่พบค่า recTotal ให้ใช้ค่า fallback
        if total_rec_count == 0 and fallback_rec_total > 0:
            print(f'ไม่พบค่า recTotal จากทุก suiteID, ใช้ค่า fallback: {fallback_rec_total}')
            return {
                'success': True,
                'recTotal': fallback_rec_total,
                'source': 'fallback',
                'details': details
            }
        
        return {
            'success': True,
            'recTotal': total_rec_count,
            'source': 'api',
            'details': details
        }
        
    except Exception as error:
        print(f'เกิดข้อผิดพลาดในการดึงข้อมูลจาก Zentao API: {str(error)}')
        
        return {
            'success': False,
            'recTotal': config.get('zentao', {}).get('fallbackRecTotal', 0),
            'message': str(error)
        }