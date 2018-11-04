#!/bin/bash
tput clear

# If already installed
if [ -d /etc/server-setup ]; then
    echo "$(tput setaf 2)$(tput bold)Server Setup Script$(tput sgr 0) has already been installed."
    echo "Enter $(tput bold)server-setup$(tput sgr 0) to start."
    exit 1
fi

echo "Installing $(tput setaf 2)$(tput bold)Server Setup Script$(tput sgr 0)..."

# Install minimal requirement
sudo apt-get -y -qq install git

# Grab the repo
sudo git clone https://github.com/gummi-io/Nginx-Reversed-LAMP-Full-Stack /etc/server-setup --quiet

# Permission
sudo chmod 600 -R /etc/server-setup
sudo chown $(whoami): -R /etc/server-setup

# Aliases
if [ ! -f ~/.bash_aliases ]; then
    sudo touch ~/.bash_aliases
fi

echo "alias server-setup='bash /etc/server-setup/run.sh'" >> ~/.bash_aliases
source ~/.bash_aliases

# Self destroy
sudo rm -Rf $(readlink -f $0)

# Done
echo "   ____                       ____    __          "
echo "  / __/__ _____  _____ ____  / __/__ / /___ _____ "
echo " _\ \/ -_) __/ |/ / -_) __/ _\ \/ -_) __/ // / _ \\"
echo "/___/\__/_/  |___/\__/_/   /___/\__/\__/\_,_/ .__/"
echo "                                           /_/    "

echo "$(tput setaf 2)$(tput bold)Server Setup Script$(tput sgr 0) has been installed successfully."
echo "Enter $(tput bold)server-setup$(tput sgr 0) to start."
