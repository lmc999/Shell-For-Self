#!/bin/bash

#适用centos7
#关闭firewalld
systemctl stop firewalld
systemctl disable firewalld

#安装iptables
yum install -y iptables-services 
systemctl enable iptables 
systemctl start iptables 

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
