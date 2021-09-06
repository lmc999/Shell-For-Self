#!/bin/bash
apt update && apt install unzip -y
wget -O ./n2n.zip https://github.com/lucktu/n2n/raw/master/Linux/n2n_v3_linux_x64_v2.9.0_r873_static_by_heiye.zip
unzip n2n.zip -d /root/
mv edge /usr/sbin/edge && chmod +x /usr/sbin/edge
rm edge_upx  n2n.zip  supernode  supernode_upx
