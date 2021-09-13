#! /bin/bash
yum install wget -y
yum install unzip -y
yum install mtr -y
wget -O /tmp/besttrace.zip https://cdn.ipip.net/17mon/besttrace4linux.zip
unzip -d /tmp /tmp/besttrace.zip
mv /tmp/besttrace ~/besttrace
chmod +x ~/besttrace
rm -rf /tmp/besttrace*
wget -O ./worsttrace https://pkg.wtrace.app/linux/worsttrace
chmod +x worsttrace
wget https://github.com/zu1k/nali/releases/download/v0.2.2/nali-linux-amd64-v0.2.2.gz
gunzip nali-linux-amd64-v0.2.2.gz
mv ./nali-linux-amd64-v0.2.2 /usr/bin/nali
chmod +x /usr/bin/nali
