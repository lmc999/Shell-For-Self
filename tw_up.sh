#! /bin/bash
nohup ping -I tun2 10.211.254.254 >/dev/null 2>&1 &
ip route add default via $(ip addr show tun2 | grep inet | awk '{print $4}' | cut -f1 -d"/" | awk NR==1)  dev tun2 table taiwan >/dev/null 2>&1
