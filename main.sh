#!/bin/bash

# check ubuntu version
echo "$(tput setaf 2)$(tput bold)Prepare to start... $(tput sgr 0)"
lsb_release -a

# secondary user
echo "$(tput setaf 2)$(tput bold)Setup secondary sudo user... $(tput sgr 0)"
adduser --gecos "" gummi
usermod -aG sudo gummi

# update server
echo "$(tput setaf 2)$(tput bold)Update apt repositories... $(tput sgr 0)"
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:nginx/development
sudo add-apt-repository -y ppa:ondrej/php
sudo add-apt-repository -y ppa:ondrej/apache2
sudo add-apt-repository -y ppa:chris-lea/redis-server
sudo apt-get -y update
sudo apt-get -y upgrade

# swap file for low memory server
echo "$(tput setaf 2)$(tput bold)Create swap 1G file... $(tput sgr 0)"

if [ -f /swapfile ]; then
    echo "'/swapfile' already exists."
else
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo swapon --show
    sudo cp /etc/fstab /etc/fstab.bak
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# fail 2 ban
echo "$(tput setaf 2)$(tput bold)Install securities... $(tput sgr 0)"
sudo apt-get -y install fail2ban unattended-upgrades landscape-common

# firewall
echo "$(tput setaf 2)$(tput bold)Setup Firewall... $(tput sgr 0)"
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

# timezone
echo "$(tput setaf 2)$(tput bold)Install timezone... $(tput sgr 0)"
sudo timedatectl set-timezone America/Vancouver
sudo apt-get -y install ntp

# basic modules
echo "$(tput setaf 2)$(tput bold)Install mics command... $(tput sgr 0)"
sudo apt-get -y install git tmux vim curl wget zip unzip htop dos2unix whois bc

# Enable sftp
echo "$(tput setaf 2)$(tput bold)Create sftp user group... $(tput sgr 0)"
sudo addgroup -q --system sftpUsers
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.back
sudo sed -i "s%Subsystem sftp /usr/lib/openssh/sftp-server%Subsystem sftp internal-sftp%" /etc/ssh/sshd_config
sftpConfig=$(<./stubs/sftpUsers.conf)
sudo echo -e "$sftpConfig" >> /etc/ssh/sshd_config
sudo service ssh reload

# apache
echo "$(tput setaf 2)$(tput bold)Install Apache... $(tput sgr 0)"
sudo apt-get -y install apache2 build-essential apache2-dev apache2-utils

wget http://mirrors.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
sudo dpkg -i libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
sudo apt install -f
sudo rm -Rf libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb

sudo sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
echo "ServerName localhost" >> /etc/apache2/conf-available/server-name.conf
sudo a2enconf server-name
sudo a2dissite 000-default
sudo hostnamectl set-hostname localhost
sudo service apache2 restart

# php 7
echo "$(tput setaf 2)$(tput bold)Install PHP7.1... $(tput sgr 0)"
sudo apt-get -y install php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql
sudo apt-get -y install php7.1-pgsql php7.1-imap php-memcached php7.1-mbstring php7.1-xml
sudo apt-get -y install php7.1-curl php7.1-bcmath php7.1-sqlite3 php7.1-xdebug php7.1-zip
ps aux | grep php

# update some ini setting
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 8M/" /etc/php/7.1/fpm/php.ini

# connect apache to php
sudo a2enmod actions
sudo a2enmod proxy_fcgi setenvif
sudo a2enmod rewrite
sudo a2enconf php7.1-fpm
sudo cp /etc/apache2/mods-available/fastcgi.conf /etc/apache2/mods-available/fastcgi.conf.backup
sudo cp ./stubs/fastcgi.conf -rf /etc/apache2/mods-available/fastcgi.conf

# nginx
echo "$(tput setaf 2)$(tput bold)Install Nginx... $(tput sgr 0)"
sudo apt-get -y install nginx
sudo rm /etc/nginx/sites-enabled/default

# reverse proxy setup
echo "$(tput setaf 2)$(tput bold)Install rpaf... $(tput sgr 0)"
sudo wget https://github.com/gnif/mod_rpaf/archive/stable.zip
sudo unzip stable.zip
cd mod_rpaf-stable
sudo make
sudo make install
cd ..
sudo cp ./stubs/rpaf.load -rf /etc/apache2/mods-available/rpaf.load
sudo cp ./stubs/rpaf.conf -rf /etc/apache2/mods-available/rpaf.conf
sudo a2enmod rpaf
sudo rm -Rf mod_rpaf-stable
sudo rm -Rf stable.zip

# restart
echo "$(tput setaf 2)$(tput bold)Restarting services... $(tput sgr 0)"
sudo service nginx restart
sudo service php7.1-fpm restart
sudo service apache2 restart

# mysql
echo "$(tput setaf 2)$(tput bold)Install Mysql... $(tput sgr 0)"
sudo apt-get -y install mysql-server

echo "$(tput setaf 2)$(tput bold)Config Mysql... $(tput sgr 0)"
sudo mysql_secure_installation

# compposer
echo "$(tput setaf 2)$(tput bold)Install Composer... $(tput sgr 0)"
sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer
sudo crontab -l | { cat; echo "5 8 * * Sat /usr/bin/composer self-update -q"; } | crontab -

# node
echo "$(tput setaf 2)$(tput bold)Install Node... $(tput sgr 0)"
sudo apt-get -y install build-essential libssl-dev
sudo curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node # no sudo...

# laravel requirements
echo "$(tput setaf 2)$(tput bold)Install Laravel requirements... $(tput sgr 0)"
sudo apt-get -y install redis-server supervisor sqlite3 memcached beanstalkd
/etc/init.d/beanstalkd start

# Let's Encrypt (Using certbot-auto to always have latest version)
echo "$(tput setaf 2)$(tput bold)Install Let's Encrypt... $(tput sgr 0)"
sudo wget https://dl.eff.org/certbot-auto
sudo chmod a+x ./certbot-auto
sudo mv ./certbot-auto /usr/bin/
sudo crontab -l | { cat; echo "15 3 * * * /usr/bin/certbot-auto renew --quiet --renew-hook 'service nginx reload'"; } | crontab -
#sudo crontab -e
# >>> "15 3 * * * /usr/bin/certbot-auto renew --quiet"

# Diffie-Hellman Parameters
echo "$(tput setaf 2)$(tput bold)Generate dhparam.pem... $(tput sgr 0)"
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# Laravel Installer
echo "$(tput setaf 2)$(tput bold)Install Laravel installer... $(tput sgr 0)"
composer global require "laravel/installer"
echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc
source ~/.bashrc

# Wp Installer
echo "$(tput setaf 2)$(tput bold)Install WP Cli... $(tput sgr 0)"
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Global Userful Bash
echo "$(tput setaf 2)$(tput bold)Add Aliases... $(tput sgr 0)"
echo "alias nah=\"git reset --hard; git clean -df;\"" >> /etc/profile.d/shared-alias.sh

# Root useful bash
echo "alias retest=\"apachectl -t; nginx -t;\"" >> ~/.bash_aliases
echo "alias reload=\"service apache2 reload; service nginx reload; service php7.1-fpm reload; echo 'Reloaded\!';\"" >> ~/.bash_aliases
echo "alias restart=\"service apache2 restart; service nginx restart; service php7.1-fpm restart; echo 'Restarted\!';\"" >> ~/.bash_aliases
echo "alias stats=\"landscape-sysinfo\"" >> ~/.bash_aliases
source ~/.bash_aliases

# extra snippets
echo "$(tput setaf 2)$(tput bold)Copy Nginx snippets... $(tput sgr 0)"
sudo cp ./snippets/nginx-gzip.conf /etc/nginx/snippets/nginx-gzip.conf
sudo cp ./snippets/agent-filters.conf /etc/nginx/snippets/agent-filters.conf
sudo cp ./snippets/security.conf /etc/nginx/snippets/security.conf
sudo cp ./snippets/static.conf /etc/nginx/snippets/static.conf
sudo cp ./snippets/nginx-ssl.conf /etc/nginx/snippets/nginx-ssl.conf
sudo cp ./snippets/proxy-params.conf /etc/nginx/snippets/proxy-params.conf

# clean up
echo "$(tput setaf 2)$(tput bold)Cleaning up... $(tput sgr 0)"
sudo apt-get -y autoremove
sudo apt-get -y update
sudo apt-get -y upgrade
sudo service nginx restart
sudo service php7.1-fpm restart
sudo service apache2 restart

echo "$(tput setaf 2)$(tput bold)Boom DONE\! $(tput sgr 0)"
