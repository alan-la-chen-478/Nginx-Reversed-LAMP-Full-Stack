#!/bin/bash

sudo nginx -t
sudo apachectl -t
sudo service php7.1-fpm reload
sudo service nginx reload
sudo service apache2 reload
