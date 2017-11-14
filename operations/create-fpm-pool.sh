#!/bin/bash

if [ -f "$POOL_FILE" ]; then
    echo "'$POOL_FILE' already exists."
else
    sudo cp ./stubs/fpm-pool.conf $POOL_FILE
    sudo sed -i "s/{{USER}}/${USER}/g" $POOL_FILE

    echo "'$POOL_FILE' created."
fi
