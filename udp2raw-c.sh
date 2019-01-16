#!/bin/bash
cd /usr/local/bin
curl -o udp2raw https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/udp2raw
chmod +x /usr/local/bin/udp2raw
nohup udp2raw -c -r44.55.66.77:9898 -l 127.0.0.1:9999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &

cat > /etc/rc.d/init.d/udp<<-EOF
#!/bin/sh
#chkconfig: 2345 80 90
#description:udp
nohup udp2raw -c -r44.55.66.77:9898 -l 127.0.0.1:9999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &
EOF

chmod +x /etc/rc.d/init.d/udp
chkconfig --add udp
chkconfig udp on
