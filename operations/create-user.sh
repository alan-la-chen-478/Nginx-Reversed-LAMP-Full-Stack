#!/bin/bash

if [ -z "$(getent passwd $USER)" ]; then
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
