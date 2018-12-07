#!/bin/bash

cd /usr/local/bin
curl -o speederv2 https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/speederv2
curl -o udp2raw https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/udp2raw
chmod +x speederv2 udp2raw

#增加自启动脚本
cat > /etc/rc.d/init.d/udp<<-EOF
#!/bin/sh
#chkconfig: 2345 80 90
#description:udp
nohup speederv2 -c -l0.0.0.0:2099 -r127.0.0.1:9999 -f2:4 --mode 0 --report 10 --timeout 0 >speeder.log 2>&1 &
nohup udp2raw -c -r52.79.95.244:9898 -l 127.0.0.1:9999 --raw-mode faketcp -k passwd >udp2raw.log 2>&1 &
EOF

#设置脚本权限
chmod +x /etc/rc.d/init.d/udp
chkconfig --add udp
chkconfig udp on
