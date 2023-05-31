#!/bin/bash
# updating packages
sudo apt update
sudo apt upgrade

# Installing Zabbix Proxy 6.5
wget https://repo.zabbix.com/zabbix/6.5/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.5-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.5-1+ubuntu22.04_all.deb
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

# securing database
sudo mysql_secure_installation

# Creating database
sudo mysql -uroot -p'rootDBpass' -e "create database zabbix_proxy character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -uroot -p'rootDBpass' -e "grant all privileges on zabbix_proxy.* to zabbix@localhost identified by 'zabbixDBpass';"

# Importing Initial Schema
sudo cat /usr/share/zabbix-sql-scripts/mysql/proxy.sql | mysql --default-character-set=utf8mb4 -uzabbix -p'zabbixDBpass' zabbix_proxy

# Configuring Zabbix proxy
sudo nano /etc/zabbix/zabbix_proxy.conf

# Enabling Zabbix Proxy
sudo systemctl restart zabbix-proxy
sudo systemctl enable zabbix-proxy