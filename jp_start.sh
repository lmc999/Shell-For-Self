#! /bin/bash
pid=$(ps -aux | grep jp.ovpn |grep -v grep |awk '!/#/{printf$2"\n"}')
num=$1
kill -9 $pid
rm -rf /tmp/jp.ovpn /tmp/vpngate.txt
setup_config(){
curl http://www.vpngate.net/api/iphone/ > /tmp/vpngate.txt


cat /tmp/vpngate.txt | grep Japan | grep -v Academic | cut -f15 -d"," |  awk NR==${num} > /tmp/jp.coded

base64 -id /tmp/jp.coded > /tmp/jp.ovpn
dos2unix /tmp/jp.ovpn >/dev/null 2>&1

sed -i '/persist-tun/d' /tmp/jp.ovpn

echo "pull-filter ignore redirect-gateway
route 10.211.0.0 255.255.0.0
dev tun0
log-append /tmp/openvpn.log
up /etc/openvpn/jp_up.sh
script-security 2
reneg-sec 0" >> /tmp/jp.ovpn

nohup openvpn --config /tmp/jp.ovpn >/dev/null 2>&1 &
}


setup_config
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
nslookup api.abema.io >/dev/null 2>&1
