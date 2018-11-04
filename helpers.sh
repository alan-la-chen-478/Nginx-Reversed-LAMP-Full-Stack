#!/bin/bash


ss-header() {
    local TEXT=$1
    TEXT=${TEXT//\[/$(tput bold)}
    TEXT=${TEXT//\]/$(tput sgr 0)$(tput setaf 2)}
    echo "$(tput setaf 2)$TEXT$(tput sgr 0)"
}

ss-header-f() {
    local TEXT=$1
    TEXT=${TEXT//\[/$(tput bold)}
    TEXT=${TEXT//\]/$(tput sgr 0)$(tput setaf 2)}
    printf "$(tput setaf 2)$TEXT$(tput sgr 0)"
}

ss-text() {
    local TEXT=$1
    TEXT=${TEXT//\[/$(tput bold)}
    TEXT=${TEXT//\]/$(tput sgr 0)}
    echo "$TEXT"
}

ss-text-f() {
    local TEXT=$1
    TEXT=${TEXT//\[/$(tput bold)}
    TEXT=${TEXT//\]/$(tput sgr 0)}
    printf "$TEXT"
}


# echo "$(tput setaf 2)asdfasdf $(tput bold)adsfasdf$(tput normal) qwerqwerwe $(tput sgr 0)"