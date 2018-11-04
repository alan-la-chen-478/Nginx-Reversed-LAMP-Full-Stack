
ss-header 'Install PHP and use Apache as reverse proxy on Nginx.'
ss-text ''

# update server
ss-header 'Update apt repositories...'
sudo apt-get -y update
sudo apt-get -y upgrade

# apache
ss-header 'Install Apache2.'
# sudo apt-get -y install apache2 build-essential apache2-dev apache2-utils
ss-text-f 'Installing apache2, php-fpm...'
sudo apt -y -qq install apache2 php7.1-fpm
ss-text '[Done]'

ss-text-f 'Installing fastcgi...'
wget --quiet https://mirrors.edge.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
sudo dpkg -i libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
sudo rm -Rf libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb
ss-text '[Done]'

ss-text-f 'Configuring apache...'
sudo mv /etc/apache2/ports.conf /etc/apache2/ports.conf.default
echo "Listen 8080" | sudo tee /etc/apache2/ports.conf
echo "ServerName localhost" >> /etc/apache2/conf-available/server-name.conf
sudo a2enconf server-name
sudo a2dissite 000-default
sudo hostnamectl set-hostname localhost
sudo service apache2 restart
ss-text '[Done]'

# php 7
ss-text-f 'Installing PHP7.1...'
sudo apt-get -y -qq install php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-imagick php7.1-mysql
sudo apt-get -y -qq install php7.1-pgsql php7.1-imap php-memcached php7.1-mbstring php7.1-xml
sudo apt-get -y -qq install php7.1-curl php7.1-bcmath php7.1-sqlite3 php7.1-xdebug php7.1-zip
ss-text '[Done]'

# connect apache to php
ss-text-f 'Connecting apache to PHP...'
sudo a2enmod actions
sudo a2enmod proxy_fcgi setenvif
sudo a2enmod rewrite
sudo a2enconf php7.1-fpm
sudo cp /etc/apache2/mods-available/fastcgi.conf /etc/apache2/mods-available/fastcgi.conf.default
sudo cp "$DIRPATH/stubs/fastcgi.conf" -rf /etc/apache2/mods-available/fastcgi.conf
ss-text '[Done]'


# update some ini setting
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 8M/" /etc/php/7.1/fpm/php.ini

