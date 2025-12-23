import requests
import json
import logging
import socket
import ssl
import urllib 
import urllib.request
import http.client
from objectpath import Tree
from urllib.error import HTTPError
#from anytree import Node, RenderTree
print("Starting")
# url = "{}:{}/{}{}".format(base_uri, api_port, base_path, endpoint)

req_url = "https://192.168.24.227:10015/api/v1/empsql/empCoverage/SYSDEMO/0023"

upd_url = "https://192.168.24.227:10015/api/v1/empsql/empCoverage/SYSDEMO/0023?empId=23&selDate=2002-11-16&termDate=2003-11-15&typeCode=M&insPlanCode=015&occNbr=4"

#url2 = "https://192.168.24.227:10015/api/v1/empsql/empCoverage/SYSDEMO/0023?empId=23&selDate=2002-11-16&termDate=2003-11-15&insPlanCode=016&occNbr=4"
#DATA = b"{'empId': 23, 'selDate': '2002-12-15', 'termDate': '2003-12-15', 'typeCode': 'M', 'insPlanCode': '004', 'occNbr': 4}"


# set credentials for basic authorization
credentials="SVNQREM6RElSSzEyMw=="
context = ssl.create_default_context();
context.check_hostname=False
context.verify_mode=ssl.CERT_NONE
headers={'Authorization' : 'Basic ' + credentials, "Content-Type": "application/json"  }


print('----')
print("before update call - inline parms")
req = urllib.request.Request(upd_url, headers=headers,method="PUT")
with urllib.request.urlopen(req, timeout=10, context=context) as f:
   pass
print(f.status)
print(f.reason)
  

print("before get request")
request = urllib.request.Request(req_url, headers=headers)
resp = urllib.request.urlopen(request, timeout=3, context=context)
response = json.loads(resp.read())

print("empid selDate    termDate typeCode insPlanCode seq")
seq=0
for  data in response:
  seq = seq + 1
  empid = data["empId"]
  selDate = data["selDate"]
  termDate = data["termDate"]
  typeCode = data["typeCode"]
  insPlanCode = data["insPlanCode"]
  print(empid,'  ',selDate,termDate,' ',typeCode,'      ',insPlanCode,'     ',seq)
print("------")
print(response[3])

print('Exit')