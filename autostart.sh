#!/bin/bash

if [ "$1" == "on" ]; then
    if test -f ~/.config/autostart/weatherwalls.desktop; then
        echo "App is already in autostart"
    else
        cp weatherwalls.desktop ~/.config/autostart/
        echo "Added to autostart"
    fi

elif [ "$1" == "off" ]; then
    if test -f ~/.config/autostart/weatherwalls.desktop; then
        rm ~/.config/autostart/weatherwalls.desktop
        echo "Removed from autostart"
    else
        echo "App is not in autostart"
    fi
fi