#!/bin/bash

#适用centos7

#安装epel源
yum -y install wget

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

#下载udpspeeder和udp2raw （amd64版）
mkdir /usr/src/udp
cd /usr/src/udp
curl -o speederv2 https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/speederv2
curl -o udp2raw https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/udp2raw
chmod +x speederv2 udp2raw

#启动udpspeeder和udp2raw
nohup ./speederv2 -c -l0.0.0.0:2099 -r127.0.0.1:9999 -f2:4 --mode 0 --report 10 --timeout 0 >speeder.log 2>&1 &
nohup ./udp2raw -c -r44.55.66.77:9898 -l 127.0.0.1:9999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &

#增加自启动脚本
cat > /etc/rc.d/init.d/udp<<-EOF
#!/bin/sh
#chkconfig: 2345 80 90
#description:udp
cd /usr/src/udp
nohup ./speederv2 -c -l0.0.0.0:2099 -r127.0.0.1:9999 -f2:4 --mode 0 --report 10 --timeout 0 >speeder.log 2>&1 &
nohup ./udp2raw -c -r44.55.66.77:9898 -l 127.0.0.1:9999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &
EOF

#设置脚本权限
chmod +x /etc/rc.d/init.d/udp
chkconfig --add udp
chkconfig udp on
