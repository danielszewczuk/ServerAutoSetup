#!/bin/bash
echo "Choose SSH port"
read sshport
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sed -i '/nameserver/d' /etc/resolv.conf
sudo timedatectl set-timezone Europe/Warsaw
apt update -y
apt upgrade -y
apt install git unattended-upgrades python3 pip fail2ban ufw -y
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
# curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash
sed -i s/#Port 22/Port $sshport/g /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i '/^\[sshd\]/{:a;N;/^\[/{i\enabled = true\nport = <twój_nowy_port_ssh>\nfilter = sshd\nlogpath = /var/log/auth.log\nmaxretry = 3\nbantime = 3600\n};ba}' /etc/fail2ban/jail.local
sudo ufw allow OpenSSH
sudo ufw enable

