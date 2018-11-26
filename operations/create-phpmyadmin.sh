#!/bin/bash

if [[ $DOMAIN == *"phpmyadmin."* ]]; then
    echo "$(tput setaf 2)$(tput bold)Installing phpMyAdmin... $(tput sgr 0)"
    phpmyadminLocation="https://files.phpmyadmin.net/phpMyAdmin/4.7.5/phpMyAdmin-4.7.5-all-languages.zip"
    phpmyadminFolderName="phpMyAdmin-4.7.5-all-languages"

    sudo wget $phpmyadminLocation -O phpmyadmin.zip
    sudo unzip -q phpmyadmin.zip -d phpmyadmin
    sudo rm phpmyadmin.zip

    sudo mv phpmyadmin/$phpmyadminFolderName/* "${SERVED_PATH}"
    sudo rm -Rf phpmyadmin
fi
