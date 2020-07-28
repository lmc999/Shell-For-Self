#! /bin/bash
pid=$(ps -aux | grep tw.ovpn |grep -v grep |awk '!/#/{printf$2"\n"}')
num=$1
kill -9 $pid
rm -rf /tmp/tw.ovpn /tmp/vpngate.txt
setup_config(){
cat /etc/openvpn/tw/tw$num.ovpn >> /tmp/tw.ovpn


sed -i '/persist-tun/d' /tmp/tw.ovpn

echo "route-nopull
route 10.211.0.0 255.255.0.0
dev tun2
log-append /tmp/openvpn.log
up /etc/openvpn/tw_up.sh
script-security 2
reneg-sec 0" >> /tmp/tw.ovpn

nohup openvpn --config /tmp/tw.ovpn >/dev/null 2>&1 &
}

make_script(){
sleep 5
ip route add default via $(ip addr show tun2 | grep inet | awk '{print $4}' | cut -f1 -d"/" | awk 'NR==1') dev tun2 table taiwan


}

setup_config
make_script
iptables -A INPUT -i tun2 -j ACCEPT
iptables -A FORWARD -i tun2 -j ACCEPT




