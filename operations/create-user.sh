#!/bin/bash

if [ -z "$(getent passwd $USER)" ]; then
    echo "$(tput setaf 2)$(tput bold)Creating New User... $(tput sgr 0)"
    sudo adduser --gecos "" $USER
    sudo usermod -d $HOME_DIR $USER

    if [ "$SSH" = false ] ; then
        sudo usermod -s /bin/false $USER # disable ssh
    fi

    if [ "$SFTP" = true ] ; then
        sudo usermod -a -G sftpUsers $USER #enable SFTP
    fi

    echo "User: '$USER' created."
else
    echo "User: '$USER' already exists."
fi
