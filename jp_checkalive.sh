#! /bin/bash
result=$(ping -I tun0 10.211.254.254 -c1 -w1| grep '100%' | awk '{print $6}' | cut -f1 -d'%')
if [ -n "${result}" ]
then 
	bash /etc/openvpn/jp_start.sh 1
else
	exit 0
fi
