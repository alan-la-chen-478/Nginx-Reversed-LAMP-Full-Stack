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

    # NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    # echo "user=$USER" | sudo tee --append "${HOME_DIR}.mysql"
    # echo "password=$NEW_UUID" | sudo tee --append "${HOME_DIR}.mysql"

    # mysql -e "CREATE USER IF NOT EXISTS '${USER}'@'localhost' IDENTIFIED BY '${NEW_UUID}';"
    # mysql -e "GRANT ALL PRIVILEGES ON \`${USER}_%\`.* TO '${USER}'@'localhost' WITH GRANT OPTION;"

    # sudo chown root: $HOME_DIR/.mysql
    # echo "MySQL User: '$USER' | '$NEW_UUID' created."
else
    echo "User: '$USER' already exists."
fi
