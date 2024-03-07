#!/bin/bash

# 检查nginx版本
nginx_version=$(nginx -v 2>&1)
nginx_version=${nginx_version#*nginx/}

# 使用版本比较逻辑，确保仅在1.23或更高版本时执行替换
if [[ $(echo -e "1.23\n$nginx_version" | sort -V | head -n1) = "1.23" ]] && ! [[ $nginx_version = "1.23" ]]; then
  echo "Nginx version is $nginx_version, which is equal to or newer than 1.23. Proceeding with service file update."
  
  # 创建新的nginx.service文件内容
  cat >/etc/systemd/system/nginx.service <<EOL
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
TimeoutStopSec=5
KillMode=mixed
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOL

  # 重新加载systemd管理器配置
  systemctl daemon-reload
  
  # 启用nginx服务，确保开机自启
  systemctl enable nginx
  
  echo "Nginx service file has been replaced with 'Restart=always' and enabled for startup."
else
  echo "Nginx version is $nginx_version. It is older than 1.23, or it's exactly 1.23. No changes are needed."
fi
