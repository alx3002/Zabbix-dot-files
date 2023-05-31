#!/bin/bash
# updating packages

# Installing Zabbix Agent 6.4
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_latest+ubuntu22.04_all.deb
sudo apt update
sudo apt -y install zabbix-agent

#Configuring Zabbix agent 6.4
cd /etc/zabbix
sudo wget -N https://raw.githubusercontent.com/Gianlucas94/Zabbix-dot-files/main/zabbix_agentd.conf

#Enabling Zabbix agent 6.4
sudo systemctl restart zabbix-agent 
sudo systemctl enable zabbix-agent

#allowing zabbix trough firewall
sudo ufw allow 10050/tcp