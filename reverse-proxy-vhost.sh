#!/bin/bash

# configurations
DOMAIN=test2.gummi.io
USER=gummi
WWW=false
SSH=true
SFTP=true
SSL=true
PROTECTED=false
HOME_DIR="/var/www/${USER}/"
VHOST_DIR="${DOMAIN}/"
SERVED_DIR=

# Add User
. ./operations/create-user.sh

# path
VHOST_PATH="${HOME_DIR}${VHOST_DIR}"
SERVED_PATH="${VHOST_PATH}public_html/${SERVED_DIR}"
. ./operations/create-path.sh

# pool
POOL_FILE="/etc/php/7.1/fpm/pool.d/${USER}.conf"
. ./operations/create-fpm-pool.sh

# nginx conf
CONF_FILE="/etc/nginx/sites-available/${DOMAIN}"
APACHE_FILE="/etc/apache2/sites-available/${DOMAIN}.conf"
. ./operations/create-apache-nginx-conf.sh

# reload
. ./operations/test-and-reload.sh

# Sample Files
. ./operations/create-sample-files.sh

# Let's encrypt
. ./operations/create-letsencrypt.sh

# phpmyadmin
. ./operations/create-phpmyadmin.sh

# password
. ./operations/create-protected.sh

# reload
. ./operations/test-and-reload.sh

echo "$(tput setaf 1)Boom DONE\! $(tput sgr 0)"
