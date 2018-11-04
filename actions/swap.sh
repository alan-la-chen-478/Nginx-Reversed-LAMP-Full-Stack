
ss-header 'Setup swap file.'
ss-text ''

# swap file for low memory server
if [ -f /swapfile ]; then
    ss-text "swapfile already exists."
else
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo swapon --show
    sudo cp /etc/fstab /etc/fstab.bak
    ss-text '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi