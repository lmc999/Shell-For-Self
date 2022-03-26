#!/bin/bash

sudo apt-get remove docker docker-engine docker.io containerd runc -y

apt-get update

apt-get install \
apt-transport-https \
ca-certificates \
curl \
gnupg \
lsb-release

checkOS() {
    os_version=$(cat /etc/os-release)
    isDebian=$(echo $os_version | grep ID=debian)
    isUbuntu=$(echo $os_version | grep ID=ubuntu)
    if [ -n "$isUbuntu" ]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    elif [ -n "$isDebian" ]; then
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    else
        echo "OS not support, quiting script"
        exit 1
    fi
}
checkOS

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y
