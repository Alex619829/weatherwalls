#!/bin/bash
if test -d /usr/local/bin/weatherwalls; then
    rm -r /usr/local/bin/weatherwalls
fi

mkdir /usr/local/bin/weatherwalls
cp -r * /usr/local/bin/weatherwalls
rm /usr/local/bin/install.sh

FILE="/etc/systemd/system/weatherwalls.service"

if [ -f "$FILE" ]; then
    rm "$FILE"
fi

cp weatherwalls.service /etc/systemd/system/
systemctl daemon-reload
systemctl start weatherwalls.service
systemctl enable weatherwalls.service