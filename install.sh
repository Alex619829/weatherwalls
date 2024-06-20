#!/bin/bash
if test -d /usr/local/bin/weatherwalls_data; then
    rm -r /usr/local/bin/weatherwalls_data
    rm /usr/local/bin/weatherwalls
fi

#cpan File::chdir
#cpan WWW::ipinfo

mkdir /usr/local/bin/weatherwalls_data
cp -r * /usr/local/bin/weatherwalls_data
rm /usr/local/bin/weatherwalls_data/install.sh

mv /usr/local/bin/weatherwalls_data/weatherwalls.pl /usr/local/bin/weatherwalls

chmod +x /usr/local/bin/weatherwalls

echo "Success: 'weatherwalls' installed to your computer"

sudo -u $SUDO_USER bash autostart.sh on
