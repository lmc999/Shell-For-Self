#! /bin/bash


# ====================================================
#	System Request:CentOS 6+ 、Debian 7+、Ubuntu 14+
#	Author:	lmc999
#	Dscription: SS-libev docker新增用户脚本
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

get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo ${IP}
}

set_user(){
    echo -e "${Green}请输入用户名(仅限英文)！${Font}"
    read -p "用户名称:" username
}

set_password(){
    echo -e "${Green}请输入连接密码(仅限英文)！${Font}"
    read -p "连接密码:" password
}

set_port(){
echo -e "${Green}请输入端口号！${Font}"
read -p "端口号:" port
}

set_configfile(){
direction=/etc/shadowsocks-libev/${username}
mkdir -p ${direction}
cat > ${direction}/config.json<<-EOF
{
"server":"0.0.0.0",
"server_port":${port},
"password":"${password}",
"timeout":300,
"method":"aes-256-gcm",
"fast_open":false,
"nameserver":"8.8.8.8",
"mode":"tcp_and_udp"
}

EOF
}


start_docker(){
docker run -d -p ${port}:${port} -p ${port}:${port}/udp --name ss-${username} --restart=always -v ${direction}:/etc/shadowsocks-libev teddysun/shadowsocks-libev
}

show_ssinfo(){
sslink=$(echo -n "aes-256-gcm:${password}@$(get_ip):${port}" | base64 -w0)
echo -e "${Green}您的SS链接为:${Font}"
echo -e "ss://${sslink}"
echo -e " "
echo -e " "
echo -e " "
}

rootness
set_user
set_password
set_port
set_configfile
start_docker
show_ssinfo
