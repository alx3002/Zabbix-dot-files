#!/bin/bash
# updating packages

# Installing Zabbix Agent 6.5
wget https://repo.zabbix.com/zabbix/6.5/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.5-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.5-1+ubuntu22.04_all.deb
sudo apt update
sudo apt -y install zabbix-agent

#Configuring Zabbix agent 6.5
cd /etc/zabbix
sudo wget -N https://raw.githubusercontent.com/Gianlucas94/Zabbix-dot-files/main/zabbix_proxy.conf

#Enabling Zabbix agent 6.5
sudo systemctl restart zabbix-agent 
sudo systemctl enable zabbix-agent

#allowing zabbix trough firewall
firewall-cmd --permanent --zone=public --add-port=10050/tcp
firewall-cmd --reload
sudo ufw allow 10050/tcp