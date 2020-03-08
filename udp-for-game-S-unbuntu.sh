#!/bin/bash

#适用ubuntu 16.04

#安装必要组件
apt-get install wget -y
apt-get install curl -y

#清除规则
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
service iptables save

#启用转发
echo 1 > /proc/sys/net/ipv4/ip_forward

#永久转发
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

#下载udpspeeder和udp2raw （amd64版）
cd /usr/local/bin
curl -o speederv2 https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/speederv2
curl -o udp2raw https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/udp2raw
chmod +x speederv2 udp2raw

#启动udpspeeder和udp2raw
nohup speederv2 -s -l0.0.0.0:9999 -r127.0.0.1:56789 -f2:4 --mode 0 --timeout 1 >speeder.log 2>&1 &
nohup udp2raw -s -l0.0.0.0:9898 -r 127.0.0.1:9999  --raw-mode faketcp -a -k passwd --fix-gro >udp2raw.log 2>&1 &

#增加自启动脚本
echo "nohup speederv2 -s -l0.0.0.0:9999 -r127.0.0.1:56789 -f2:4 --mode 0 --timeout 1 >speeder.log 2>&1 &" | sudo tee -a /etc/rc.local
echo "nohup udp2raw -s -l0.0.0.0:9898 -r 127.0.0.1:9999  --raw-mode faketcp -a -k passwd --fix-gro >udp2raw.log 2>&1 &" | sudo tee -a /etc/rc.local
