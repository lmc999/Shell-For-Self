#! /bin/bash
num=$1
killall openvpn >/dev/null 2>&1
rm -rf /tmp/jp.ovpn /tmp/vpngate.txt
setup_config(){
curl http://www.vpngate.net/api/iphone/ > /tmp/vpngate.txt


cat /tmp/vpngate.txt | grep Japan | grep -v Academic | cut -f15 -d"," |  awk 'NR==${num}' > /tmp/jp.coded

base64 -d /tmp/jp.coded > /tmp/jp.ovpn
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

make_script(){
sleep 5
ip route add default via $(ip addr show tun0 | grep inet | awk '{print $4}' | cut -f1 -d"/" | awk 'NR==1') dev tun0 table media


}

setup_config
make_script
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
