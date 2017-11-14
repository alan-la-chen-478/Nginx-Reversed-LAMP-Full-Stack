#!/bin/bash

if [ "$SSL" = true ] ; then
    echo "$(tput setaf 1)Creating SSL certificates... $(tput sgr 0)"
    sudo certbot certonly --nginx -d ${DOMAIN} --agree-tos

    # redirect
    sudo sed -i "s/# server { # SSL/server { # SSL/g" $CONF_FILE
    sudo sed -i "s/# listen 80; # SSL/listen 80; # SSL/g" $CONF_FILE
    sudo sed -i "s/# server_name ${DOMAIN}; # SSL/server_name ${DOMAIN}; # SSL/g" $CONF_FILE
    sudo sed -i "s/# return 301 https:\/\/\$server_name\$request_uri; # SSL/return 301 https:\/\/\$server_name\$request_uri; # SSL/g" $CONF_FILE
    sudo sed -i "s/# } # SSL/} # SSL/g" $CONF_FILE

    # certificates
    sudo sed -i "s/listen 80; # HTTP/# listen 80; # HTTP/g" $CONF_FILE
    sudo sed -i "s/# listen 443 /listen 443 /g" $CONF_FILE
    sudo sed -i "s/# ssl_certificate /ssl_certificate /g" $CONF_FILE
    sudo sed -i "s/# ssl_certificate_key /ssl_certificate_key /g" $CONF_FILE
    sudo sed -i "s/# ssl_trusted_certificate /ssl_trusted_certificate /g" $CONF_FILE
    sudo sed -i "s/# include snippets\/nginx-ssl.conf/include snippets\/nginx-ssl.conf/g" $CONF_FILE

    sudo nginx -t
    sudo service php7.1-fpm reload
    sudo service nginx reload

    echo "'SSL Certivicates' created."
fi
