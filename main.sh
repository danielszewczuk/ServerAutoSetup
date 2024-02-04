#!/bin/bash
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sed -i '/nameserver/d' /etc/resolv.conf
sudo timedatectl set-timezone Europe/Warsaw
apt update -y
apt upgrade -y
apt install git curl python3 pip -y
rm /usr/lib/python3.11/EXTERNALLY-MANAGED
python3 -m pip install --upgrade pip
pip install py-cord