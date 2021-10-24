#! /bin/sh

CONTAINER_ALREADY_STARTED="$HOME/.CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e "$CONTAINER_ALREADY_STARTED" ]; then
    touch "$CONTAINER_ALREADY_STARTED"

    echo "-- First container startup --"

    # update dotfiles config
    git -C "$HOME"/.dotfiles pull
else
    echo "-- Not first container startup --"
fi

exec "$@"
