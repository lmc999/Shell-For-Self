#! /bin/bash
nohup ping 10.211.254.254 >/dev/null 2>&1 &
ip route add default via $(ip addr show tun0 | grep inet | awk '{print $4}' | cut -f1 -d"/" | awk NR==1)  dev tun0 table media >/dev/null 2>&1
