#!/bin/bash
DATABASE_PASS='admin123'
This script installs and configure apache webserver for tooling website
sudo yum update -y

yum install epel-release -y

sudo dnf module reset php

sudo dnf install -y php php-opcache php-gd php-curl php-mysqlnd git

sudo systemctl start php-fpm

sudo systemctl enable php-fpm

sudo setsebool -P httpd_execmem 1

git clone https://github.com/nbomasi/tooling-1.git

sudo yum install httpd -y

sudo systemctl restart httpd

sudo systemctl status httpd

sudo setenforce 0 

yum install mariadb-server -y

cd tooling-1

mysql -h 192.168.56.20 -u webaccess -p"$DATABASE_PASS" tooling < tooling-db.sql

cp -R html/. /var/www/html

sudo sed -i 's/webaccess/192.168.56.20/1' /var/www/html/functions.php

sudo sed -i 's/admin/webaccess/; s/admin/admin123/' /var/www/html/functions.php 

sudo systemctl restart httpd