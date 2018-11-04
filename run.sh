#!/bin/bash

DIRPATH='/etc/server-setup'
OPERATION=${1:-help}

. $DIRPATH/helpers.sh

# Output server setup help
if [ $OPERATION == 'help' ] 
then
    . "$DIRPATH/actions/help.sh"
fi

# Init
if [ $OPERATION == 'init' ] 
then
    . "$DIRPATH/actions/init.sh"
fi

# Add server account
if [ $OPERATION == 'add-account' ] 
then
    echo 'add-account'
fi

# Add Swap
if [ $OPERATION == 'swap-file' ] 
then
    . "$DIRPATH/actions/swap.sh"
fi

# Firewall
if [ $OPERATION == 'open-port' ] 
then
    . "$DIRPATH/actions/open-port.sh"
fi

if [ $OPERATION == 'close-port' ] 
then
    . "$DIRPATH/actions/close-port.sh"
fi

# Reverse Nginx LAMP
if [ $OPERATION == 'php-an' ] 
then
   . "$DIRPATH/actions/php.sh"
fi

# MySQL
if [ $OPERATION == 'mysql' ] 
then
    echo 'mysql'
fi

# Composer
if [ $OPERATION == 'composer' ] 
then
    echo 'composer'
fi

# Node
if [ $OPERATION == 'node' ] 
then
    echo 'node'
fi

# Laravel
if [ $OPERATION == 'laravel' ] 
then
    echo 'laravel'
fi

# Wordpress
if [ $OPERATION == 'wp' ] 
then
    echo 'wp'
fi

# Let's Encrypt
if [ $OPERATION == 'ssl' ] 
then
    echo 'lets-encrypt'
fi



