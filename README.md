# DEPLOY A PHP 3-TIER WEB APPLICATION ON A LOCAL SYSTEM USING VAGRANT ON VIRTUAL BOX PROVIDER

*This is a documentation page that guide us through the manual deployment process of a PHP 3-tier (tooling website) apllication locally using VAGRANT on virtual box provider*

## INSTALLING AND CONFIGURING MARIADB SERVER

DATABASE_PASS='admin123'

```markdown
sudo yum update -y
sudo yum install epel-release -y
sudo yum install git zip unzip -y
sudo yum install mariadb-server -y
```


***starting & enabling mariadb-server***

```markdown
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

#restore the dump file for the application

```markdown
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database tooling"
sudo mysql -u root -p"$DATABASE_PASS" -e "create user'webaccess'@'%' identified by 'admin123';"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on tooling.* TO 'webaccess'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
```

#Restart mariadb-server

```markdown
sudo systemctl restart mariadb
```
#starting the firewall and allowing the mariadb to access from port no. 3306

```markdown
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb
```

## SETTING UP THE WEB APPLICATION ON CENTOS SERVER

DATABASE_PASS='admin123'

This script installs and configure apache webserver for tooling website

```markdown
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
```

Now browse the following local Ip

http://192.168.56.14

![website-page1](../Images/php1.png)

![website-page2](../Images/php2.png)


## SECOND WEBSITE

In this case I will be using a different source code from the 
following [repository](https://github.com/darey-devops/tooling.git)

Only the following will be edited on the db server:

```markdown
sudo mysql -u root -p"$DATABASE_PASS" -e "create database tooling"
sudo mysql -u root -p"$DATABASE_PASS" -e "create user'boma'@'%' identified by 'admin123';"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on tooling.* TO 'boma'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
```

```markdown
echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

cd tooling

cp html /var/www/

cd /var/www/html/

vi .env 
```

![db-credential](../Images/db-credentials.png)

Please note that before editing, you must have created the credentials in your db, in my case, I used my credentials above.

```markdown
sudo systemctl restart httpd
```

Then reload the web page http://192.168.56.14 and get the following output:

![php-web1](../Images/php-part2-1.png)

![php-web2](../Images/php-part2-2.png)


For automation please visit [project-automationfile](../Automation).

Please note that only the part 1 of the project is automated.