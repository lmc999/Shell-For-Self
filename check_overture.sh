#! /bin/bash

function check_overture(){
overture_status=`ps | grep /etc/overture/config.json | wc -l`
if [ 1 == $overture_status ]; then
nohup overture -c /etc/overture/config.json &
fi
}

check_overture

#overture位置 /usr/bin/overture

#overture配置文件位置 /etc/overture