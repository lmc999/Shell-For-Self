#! /bin/bash
yum install wget -y
yum install unzip -y
yum install mtr -y
wget -O ./besttrace https://raw.githubusercontent.com/lmc999/Shell-For-Self/master/besttrace
chmod +x besttrace
wget -O ./worsttrace https://pkg.wtrace.app/linux/worsttrace
chmod +x worsttrace
wget https://github.com/zu1k/nali/releases/download/v0.2.2/nali-linux-amd64-v0.2.2.gz
gunzip nali-linux-amd64-v0.2.2.gz
mv ./nali-linux-amd64-v0.2.2 /usr/bin/nali
chmod +x /usr/bin/nali
