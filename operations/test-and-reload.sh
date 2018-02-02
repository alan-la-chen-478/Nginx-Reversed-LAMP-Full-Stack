#!/bin/bash

echo "$(tput setaf 2)$(tput bold)Test and reloading services... $(tput sgr 0)"
sudo nginx -t
sudo apachectl -t
sudo service php7.1-fpm reload
sudo service nginx reload
sudo service apache2 reload
