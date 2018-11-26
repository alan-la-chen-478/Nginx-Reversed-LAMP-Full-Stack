#!/bin/bash

echo "$(tput setaf 2)$(tput bold)Creating sample files... $(tput sgr 0)"

read -r -d '' VAR <<- EOM
<!DOCTYPE html>
<html>
    <head>
        <title>${DOMAIN}</title>
    </head>
    <body>
        <center>Hello! ${DOMAIN}</center>
    </body>
</html>
EOM

if [ ! -f "${SERVED_PATH}index.php" ]; then
    echo "${VAR}" | sudo tee "${SERVED_PATH}index.php"
    echo "'${SERVED_PATH}index.php' created."
fi

if [ ! -f "${SERVED_PATH}info.php" ]; then
    echo "<?php phpinfo(); ?>" | sudo tee "${SERVED_PATH}info.php"
    echo "'${SERVED_PATH}info.php' created."
fi
