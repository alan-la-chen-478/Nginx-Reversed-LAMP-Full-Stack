
ss-header 'Initialize server.'
ss-text '[Server Info:]'
lsb_release -a
ss-text ''

if [ -f "$DIRPATH/.config/.init" ]; then
    ss-test 'Server had already been initialized.'
    exit 1
fi

# update server
ss-header 'Update apt repositories.'

ss-text-f 'Installing software-properties-common...'
sudo apt-get install -y -qq software-properties-common
ss-text '[Done]'

ss-text-f 'Adding ppa:nginx/development...'
sudo add-apt-repository -y ppa:nginx/development > /dev/null 2>&1
ss-text '[Done]'

ss-text-f 'Adding ppa:ondrej/php...'
sudo add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1
ss-text '[Done]'

ss-text-f 'Adding ppa:ondrej/apache2...'
sudo add-apt-repository -y ppa:ondrej/apache2 > /dev/null 2>&1
ss-text '[Done]'

ss-text-f 'Adding ppa:chris-lea/redis-server...'
sudo add-apt-repository -y ppa:chris-lea/redis-server > /dev/null 2>&1
ss-text '[Done]'

ss-text-f 'Upgrading apt packages...'
sudo apt-get -y -qq update > /dev/null 2>&1
sudo apt-get -y -qq upgrade > /dev/null 2>&1
ss-text '[Done]'
ss-text ''

# fail 2 ban
ss-header 'Installing security softwares...'
sudo apt-get -y -qq install fail2ban unattended-upgrades landscape-common
ss-text ''

# firewall
ss-header 'Setting up firewall...'
sudo ufw allow ssh > /dev/null 2>&1
sudo ufw allow http > /dev/null 2>&1
sudo ufw allow https > /dev/null 2>&1
sudo ufw --force enable
ss-text ''

# timezone
ss-header 'Setting up timezone and ntp synchronization...'
echo "Default timezome will be set to 'America/Vancouver', hit any key to change it (will auto continue in 5 seconds): "
read -t 5 TIMEZONE

if [ $? == 0 ]; then
    printf 'Which timezone do you want to set it to? '
    read TIMEZONE
fi

sudo timedatectl set-timezone ${TIMEZONE:-'America/Vancouver'} > /dev/null 2>&1

if [ $? != 0 ]; then
    ss-text 'Invalid Timezone, falling back to [America/Vancouver]'
    sudo timedatectl set-timezone America/Vancouver
fi

ss-text "Timezone is set to [$(timedatectl status | grep -oP 'Time zone: \K(.*)')]"
sudo apt-get -y -qq install ntp > /dev/null 2>&1
ss-text ''

# basic modules
ss-header 'Installing basic command (git vim curl wget zip unzip htop dos2unix whois bc)...'
sudo apt-get -y -qq install git vim curl wget zip unzip htop dos2unix whois bc > /dev/null 2>&1
ss-text ''

# Enable sftp
ss-header 'Creating sftp user group...'
sudo addgroup -q --system sftpUsers

if [ $(grep -q 'Match Group sftpUsers' /etc/ssh/sshd_config) ]; then # not found
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.back
    sudo sed -i "s%/usr/lib/openssh/sftp-server%internal-sftp%" /etc/ssh/sshd_config
    sftpConfig=$(<"$DIRPATH/stubs/sftpUsers.conf")
    sudo echo -e "$sftpConfig" >> /etc/ssh/sshd_config
    sudo service ssh reload
    sudo service sshd reload
fi

ss-text ''

# Caching
ss-header 'Installing caching libraries (Redis, Memcache)...'
sudo apt-get -y -qq install redis-server memcached
ss-text "$(ps -Af | grep redis-server | grep -v grep )"
ss-text "$(ps -Af | grep memcached | grep -v grep )"
ss-text ''

# useful alias
ss-header 'Installing handy aliases...'
if [ ! -f /etc/profile.d/shared-alias.sh ]; then 
    echo "alias nah='git reset --hard; git clean -df'" >> /etc/profile.d/shared-alias.sh
    echo "alias ll='ls -lahF'" >> /etc/profile.d/shared-alias.sh
    echo "alias cd='cd ..'" >> /etc/profile.d/shared-alias.sh

    echo "alias retest=\"apachectl -t; nginx -t;\"" >> ~/.bash_aliases
    echo "alias reload=\"service apache2 reload; service nginx reload; service php7.1-fpm reload; echo 'Reloaded\!';\"" >> ~/.bash_aliases
    echo "alias restart=\"service apache2 restart; service nginx restart; service php7.1-fpm restart; echo 'Restarted\!';\"" >> ~/.bash_aliases
    echo "alias stats=\"landscape-sysinfo\"" >> ~/.bash_aliases
    source ~/.bash_aliases
fi
ss-text ''

# Cleanup
ss-header 'Final clean up...'
sudo apt-get -y -qq autoremove > /dev/null 2>&1
sudo apt-get -y -qq update > /dev/null 2>&1
sudo apt-get -y -qq upgrade > /dev/null 2>&1
ss-text ''

sudo touch "$DIRPATH/.config/.init"

ss-header '[Server Init Finished!]'
