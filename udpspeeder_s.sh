#! /bin/bash
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

# ====================================================
#	System Request:CentOS 6+ 、Debian 7+、Ubuntu 14+
#	Author:	lmc999
#	Dscription: udpspeeder服务器端配置脚本
#	Version: 1.0
# ====================================================

Green="\033[32m"
Font="\033[0m"
Blue="\033[33m"

rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}

checkos(){
    if [[ -f /etc/redhat-release ]];then
        OS=CentOS
    elif cat /etc/issue | grep -q -E -i "debian";then
        OS=Debian
    elif cat /etc/issue | grep -q -E -i "ubuntu";then
        OS=Ubuntu
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
        OS=CentOS
    elif cat /proc/version | grep -q -E -i "debian";then
        OS=Debian
    elif cat /proc/version | grep -q -E -i "ubuntu";then
        OS=Ubuntu
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
        OS=CentOS
    else
        echo "Not supported OS, Please reinstall OS and try again."
        exit 1
    fi
}


get_ip(){
    ip=`curl http://whatismyip.akamai.com`
}

config_udpspeeder(){
    echo -e "${Green}请输入udpspeeder配置信息！${Font}"
    echo -e "${Blue}本脚本默认串联密码为passwd${Font}"
    read -p "请输入本地服务端口:" port1
    read -p "请输入远程串联端口:" port2
}


start_udpspeeder(){
    echo -e "${Green}正在配置udpspeeder...${Font}"
	nohup speederv2 -s -l0.0.0.0:${port2} -r 127.0.0.1:${port1} -f2:4 --mode 0 --timeout 1 -k passwd >speeder.log 2>&1 &
    if [ "${OS}" == 'CentOS' ];then
        sed -i '/exit/d' /etc/rc.d/rc.local
        echo "nohup speederv2 -s -l0.0.0.0:${port2} -r 127.0.0.1:${port1} -f2:4 --mode 0 --timeout 1 -k passwd >speeder.log 2>&1 &" >> /etc/rc.d/rc.local
	echo "sleep 2
	" >> /etc/rc.d/rc.local
        chmod +x /etc/rc.d/rc.local
    elif [ -s /etc/rc.local ]; then
        sed -i '/exit/d' /etc/rc.local
        echo "nohup speederv2 -s -l0.0.0.0:${port2} -r 127.0.0.1:${port1} -f2:4 --mode 0 --timeout 1 -k passwd >speeder.log 2>&1 &" >> /etc/rc.local
	echo "sleep 2
	" >> /etc/rc.local
        chmod +x /etc/rc.local
    else
echo -e "${Green}检测到系统无rc.local自启，正在为其配置... ${Font} "
echo "[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
 
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
 
[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/rc-local.service
echo "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
" > /etc/rc.local
echo "nohup speederv2 -s -l0.0.0.0:${port2} -r 127.0.0.1:${port1} -f2:4 --mode 0 --timeout 1 -k passwd >speeder.log 2>&1 &" >> /etc/rc.local
echo "sleep 2
" >> /etc/rc.local
chmod +x /etc/rc.local
systemctl enable rc-local >/dev/null 2>&1
systemctl start rc-local >/dev/null 2>&1
    fi
    get_ip
    sleep 3
    echo
    echo -e "${Green}udpspeeder安装并配置成功!${Font}"
    echo -e "${Blue}你的本地服务端口为:${port1}${Font}"
    echo -e "${Blue}你的远程串联端口为:${port2}${Font}"
    echo -e "${Blue}你的本地服务器IP为:${ip}${Font}"
    exit 0
}

install_udpspeeder(){
echo -e "${Green}即将安装udp2raw...${Font}"
cd /usr/local/bin
curl -o speederv2 https://raw.githubusercontent.com/lmc999/OpenvpnForGames/master/speederv2
cd

#授可执行权
chmod +x /usr/local/bin/speederv2

}

status_udpspeeder(){
    if [ -f /usr/local/bin/speederv2 ]; then
    echo -e "${Green}检测到udpspeeder已存在，并跳过安装步骤！${Font}"
        main_x
    else
        main_y
    fi
}

main_x(){
checkos
rootness
config_udpspeeder
start_udpspeeder
}

main_y(){
checkos
rootness
install_udpspeeder
config_udpspeeder
start_udpspeeder
}

status_udpspeeder
