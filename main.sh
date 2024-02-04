#!/bin/bash
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sed -i '/nameserver/d' /etc/resolv.conf
sudo timedatectl set-timezone Europe/Warsaw
apt update -y
apt upgrade -y
apt install git unattended-upgrades python3 pip -y
cat << EOF > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
unattended-upgrades --dry-run --debug
rm /usr/lib/python3.11/EXTERNALLY-MANAGED
python3 -m pip install --upgrade pip
pip install py-cord
curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash