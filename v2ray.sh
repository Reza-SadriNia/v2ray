#!/bin/bash
echo "==================================
#
      Run Update and Upgrade Your OS!!!
#
=================================="
apt update && apt upgrade -y

echo "==================================
#
      Your system is Update!!!
#
=================================="

echo "==================================
#
      Install Dependencies on Your system!!!
#
=================================="

apt install git wget curl bash-completion htop openssh-server iptables iptables-persistent certbot -y
sleep 2

echo "==================================
#
      Install Dependencies Was Successfully!!!
#
=================================="

echo "==================================
#
      Set SSH Config!!!
#
=================================="


# Change SSH PORT and Set Permit Root Login
read -p "Enter The SSH PORT Number: " SSH_PORT
sed -i "/^#.*Port /s/^#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
sed -i "/^#.*PermitRootLogin /s/^#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# Restart and enable SSH Service
sudo systemctl enable sshd.service
sudo systemctl restart sshd.service

echo "==================================
#
      SSH Config is Done!!!
#
=================================="

echo "==================================
#
      Install x-ray!!!
#
=================================="

sleep 2

echo "==================================
#
      Config Firewall!!!
#
=================================="

read -p "Which ports do you want to open? (Max 5 port , EX: port1 port2 port3 port4 port5) " port1 port2 port3 port4 port5
iptables -t filter -I INPUT -p tcp --dport $SSH_PORT -j ACCEPT
iptables -t filter -I INPUT -p tcp --dport $port1 -j ACCEPT
iptables -t filter -I INPUT -p tcp --dport $port2 -j ACCEPT
iptables -t filter -I INPUT -p tcp --dport $port3 -j ACCEPT
iptables -t filter -I INPUT -p tcp --dport $port4 -j ACCEPT
iptables -t filter -I INPUT -p tcp --dport $port5 -j ACCEPT
iptables -t filter -I INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p tcp -j DROP
iptables -t filter -I OUTPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT

# Save Firewall Config
rm /etc/iptables/rules.v4
iptables-save >/etc/iptables/rules.v4

echo "==================================
#
      Firewall is Done!!!
#
=================================="

echo "==================================
#
      Install x-ray!!!
#
=================================="

wget https://raw.githubusercontent.com/Reza-SadriNia/v2ray/main/install.sh
bash install.sh

echo "==================================
#
      install X-ray is Done!!
#
=================================="

echo "==================================
#
      Install SSL On Your Domain!!
#
=================================="

# For SSL
read -p "Enter FQDN For Your Domain: " DOMAIN
certbot certonly --standalone -d $DOMAIN --register-unsafely-without-email --non-interactive --agree-tos

echo "==================================
#
      SSL is Done!!
#
=================================="
echo "======================================="

echo "==================================
#
      V2ray is Installed!!
      Server is Configured!!
      Open url on browser: https://$DOMAIN:PortNumber
#
=================================="
