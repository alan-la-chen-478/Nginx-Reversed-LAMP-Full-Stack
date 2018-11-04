
ss-header 'Close firewall port.'

if [ -z $2 ]; then
    printf "Enter port number you'd like to close: "
    read PORT
else 
    PORT=$2
fi

sudo ufw delete allow $PORT > /dev/null 2>&1
sudo ufw reload
