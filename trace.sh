#! /bin/bash
CPUArch=$(uname -m)
if [[ "$CPUArch" == "aarch64" ]]; then
  isARM=arm
fi  
apt install unzip -y
wget -O /tmp/besttrace.zip https://cdn.ipip.net/17mon/besttrace4linux.zip
unzip -d /tmp /tmp/besttrace.zip
mv /tmp/besttrace${isARM} ~/besttrace
chmod +x ~/besttrace
rm -rf /tmp/besttrace*
