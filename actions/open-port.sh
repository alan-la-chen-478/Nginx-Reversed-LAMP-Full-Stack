
ss-header 'Open firewall port.'

if [ -z $2 ]; then
    printf "Enter port number you'd like to open: "
    read PORT
else 
    PORT=$2
fi

sudo ufw allow $PORT > /dev/null 2>&1
sudo ufw reload
