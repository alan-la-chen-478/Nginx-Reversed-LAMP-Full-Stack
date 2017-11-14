#!/bin/bash

# configurations
DOMAIN=test.gummi.io
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
. ./operations/create-user.bash

# path
VHOST_PATH="${HOME_DIR}${VHOST_DIR}"
SERVED_PATH="${VHOST_PATH}public_html/${SERVED_DIR}"
. ./operations/create-path.bash

# pool
POOL_FILE="/etc/php/7.1/fpm/pool.d/${USER}.conf"
. ./operations/create-fpm-pool.bash

# nginx conf
CONF_FILE="/etc/nginx/sites-available/${DOMAIN}"
. ./operations/create-nginx-conf.bash

# reload
. ./operations/test-and-reload.bash

# Sample Files
. ./operations/create-sample-files.bash

# Let's encrypt
. ./operations/create-letsencrypt.bash

# phpmyadmin
. ./operations/create-phpmyadmin.bash

# password
. ./operations/create-protected.bash

# reload
. ./operations/test-and-reload.bash
