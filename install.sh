#!/bin/bash
if test -d /usr/local/bin/weatherwalls; then
    rm -r /usr/local/bin/weatherwalls
fi

mkdir /usr/local/bin/weatherwalls
cp -r * /usr/local/bin/weatherwalls
rm /usr/local/bin/weatherwalls/install.sh

FILE="/etc/systemd/system/weatherwalls.service"

if [ -f "$FILE" ]; then
    systemctl stop weatherwalls.service
    rm "$FILE"
    systemctl daemon-reload

fi


cp weatherwalls.service /etc/systemd/system/

file="/etc/systemd/system/weatherwalls.service"
old_string="User=default"
new_string="User=$SUDO_USER"
sed -i -e "s|$old_string|$new_string|g" $file

systemctl daemon-reload
systemctl start weatherwalls.service
systemctl enable weatherwalls.service