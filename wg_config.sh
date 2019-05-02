#! /bin/bash


# ====================================================
#       System Request:CentOS 6+ 、Debian 7+、Ubuntu 14+
#       Author: lmc999
#       Dscription: Wireguard配置脚本
#       Version: 1.0
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

set_interface(){
    echo -e "${Green}请输入需要启动的interface配置信息！${Font}"
    read -p "interface名称:" iface
}


start_wireguard(){
    wg-quick up ${iface}
        sleep 1
        wondershaper -a ${iface} -u 5120
}

stop_wireguard(){
    wg-quick down ${iface}
        sleep 1
        wondershaper -c -a ${iface}
}

restart_wireguard(){
    wg-quick down ${iface}
        wondershaper -c -a ${iface}
        wg-quick up ${iface}
        sleep 1
        wondershaper -a ${iface} -u 5120
}

start_menu(){
    clear
    echo "1. 启动Wireguard"
    echo "2. 关闭wireguard"
    echo "3. 重启wireguard"
    echo "0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
        rootness
        set_interface
        start_wireguard
        ;;
        2)
        rootness
        set_interface
        stop_wireguard
        ;;
        3)
        rootness
        set_interface
        restart_wireguard
        ;;
        0)
        exit 1
        ;;
        *)
        clear
        echo "请输入正确数字"
        sleep 5s
        start_menu
        ;;
    esac
}

start_menu
