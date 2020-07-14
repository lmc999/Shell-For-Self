#!/usr/bin/env python
import requests

ip_ranges = requests.get('https://ip-ranges.amazonaws.com/ip-ranges.json').json()['prefixes']
amazon_ips = [item['ip_prefix'] for item in ip_ranges if item["region"] == "ap-northeast-2"] #ap-northeast-2 is seoul
ec2_ips = [item['ip_prefix'] for item in ip_ranges if item["service"] == "EC2"]

amazon_ips_less_ec2=[]
     
for ip in amazon_ips:
    if ip not in ec2_ips:
        amazon_ips_less_ec2.append(ip)

for ip in amazon_ips_less_ec2: print(str(ip))
