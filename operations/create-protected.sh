#!/bin/bash

if [ "$PROTECTED" = true ] ; then
    touch "${VHOST_PATH}.htpasswd"
    sudo htpasswd "${VHOST_PATH}.htpasswd" ${USER}
    sudo sed -i "s/# auth_basic /auth_basic /g" $CONF_FILE
    sudo sed -i "s/# auth_basic_user_file /auth_basic_user_file /g" $CONF_FILE
    sudo chown root: $CONF_FILE
    sudo chmod 0444 $CONF_FILE

    sudo nginx -t
    sudo service php7.1-fpm reload
    sudo service nginx reload
fi
