#! /bin/bash
pid=$(ps -aux | grep tw.ovpn |grep -v grep |awk '!/#/{printf$2"\n"}')
num=$1
kill -9 $pid
rm -rf /tmp/tw.ovpn
setup_config(){
server=$(curl https://freevpn.gg/s/TW | grep 'href="/c/'| awk '!/#/{printf$9"\n"}' | cut -f2 -d'"' | awk NR==${num})


curl https://freevpn.gg${server}/udp >> /tmp/tw.ovpn

sed -i '/persist-tun/d' /tmp/tw.ovpn

echo "pull-filter ignore redirect-gateway
route 10.211.0.0 255.255.0.0
dev tun1
log-append /tmp/openvpn.log
up /etc/openvpn/tw_up.sh
script-security 2
reneg-sec 0" >> /tmp/tw.ovpn

nohup openvpn --config /tmp/tw.ovpn &
}


setup_config
iptables -A INPUT -i tun1 -j ACCEPT
iptables -A FORWARD -i tun1 -j ACCEPT
