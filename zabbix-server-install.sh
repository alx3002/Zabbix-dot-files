#!/bin/bash
# updating packages
sudo apt update
sudo apt upgrade

# Installing Zabbix Server 6.4
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_latest+ubuntu22.04_all.deb
sudo apt update
sudo apt -y install zabbix-proxy-mysql zabbix-sql-scripts

# Installing Database
sudo apt install software-properties-common -y
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --mariadb-server-version=10.6
sudo apt update
sudo apt -y install mariadb-common mariadb-server-10.6 mariadb-client-10.6
sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo mysql -uroot -p'rootDBpass' -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -uroot -p'rootDBpass' -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbixDBpass';"

sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p'zabbixDBpass' zabbix

# Configuring Zabbix
cd /etc/zabbix
sudo wget -N https://raw.githubusercontent.com/Gianlucas94/Zabbix-dot-files/main/zabbix_server.conf

# Configuring Firewall
ufw allow 10050/tcp
ufw allow 10051/tcp
ufw allow 80/tcp
ufw reload

# Starting and Enabling Zabbix Server
sudo systemctl restart zabbix-server zabbix-agent 
sudo systemctl enable zabbix-server zabbix-agent

# Configuring frontEnd
sudo nano /etc/zabbix/apache.conf
php_value date.timezone Europe/Amsterdam
sudo systemctl restart apache2
sudo systemctl enable apache2