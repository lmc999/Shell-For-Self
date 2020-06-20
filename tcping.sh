#! /bin/bash
yum install wget -y
yum install unzip -y
yum install mtr -y

wget https://github.com/cloverstd/tcping/releases/download/v0.1.1/tcping-linux-amd64-v0.1.1.tar.gz
tar -zxvf tcping-linux-amd64-v0.1.1.tar.gz
rm -rf tcping-linux-amd64-v0.1.1.tar.gz
chmod +x tcping
