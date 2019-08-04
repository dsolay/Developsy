#! /bin/bash

#!/bin/bash
# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

#containers=$(sudo -E docker-compose ps | gawk '{print $1}' FS=" ")

# funtions

start-docker() {
    local docker=$(ps awx | grep 'docker' | grep -v grep | wc -l)
    if [ $docker == 0 ]; then
        echo "Start docker..."
        sudo systemctl start docker
    fi
}

lamp() {
    sudo -E docker-compose up -d db proxy phpmyadmin
}

passbolt() {
    if [[ ! -n $(sudo docker ps --filter="name=passbolt" -q)  ]]; then
        echo "Start passbolt..."
        sudo -E docker-compose up -d passbolt
    fi

    #
}

start-docker

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=dfo:v

LONGOPTS=(
    "mariadb"
    "phpmyadmin"
    "passbolt"
    "payara"
    "lamp"
    "help"
)

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt \
            --options "" \
            --longoptions "$(printf "%s," "${LONGOPTS[@]}")" \
            --name "$(basename $0)" \
            -- "$@")

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi

# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        --lamp)
            lamp
            shift
            ;;
        --passbolt)
            passbolt
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done