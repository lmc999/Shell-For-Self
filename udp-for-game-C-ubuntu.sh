#!/bin/bash

#适用ubuntu 16.04


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


#下载udpspeeder和udp2raw （amd64版）
cd /usr/local/bin
curl -o speederv2 https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/speederv2
curl -o udp2raw https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/udp2raw
chmod +x speederv2 udp2raw

#启动udpspeeder和udp2raw
nohup speederv2 -c -l0.0.0.0:2099 -r127.0.0.1:9999 -f2:4 --mode 0 --report 10 --timeout 0 >speeder.log 2>&1 &
nohup udp2raw -c -r44.55.66.77:9898 -l 127.0.0.1:9999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &
nohup speederv2 -c -l0.0.0.0:2098 -r127.0.0.1:8999 -f2:4 --mode 0 --report 10 --timeout 0 >speeder.log 2>&1 &
nohup udp2raw -c -r44.55.66.77:8898 -l 127.0.0.1:8999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &

#增加自启动脚本
echo "nohup speederv2 -c -l0.0.0.0:2099 -r127.0.0.1:9999 -f2:4 --mode 0 --report 10 --timeout 0 >speeder1.log 2>&1 &" | sudo tee -a /etc/rc.local
echo "nohup udp2raw -c -r44.55.66.77:9898 -l 127.0.0.1:9999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &" | sudo tee -a /etc/rc.local
echo "nohup speederv2 -c -l0.0.0.0:2098 -r127.0.0.1:8999 -f2:4 --mode 0 --report 10 --timeout 0 >speeder2.log 2>&1 &" | sudo tee -a /etc/rc.local
echo "nohup udp2raw -c -r44.55.66.77:8898 -l 127.0.0.1:8999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &" | sudo tee -a /etc/rc.local
