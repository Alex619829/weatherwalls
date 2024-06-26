#!/usr/bin/perl
use strict;
use warnings;
use lib '/usr/local/bin/weatherwalls_data';
use Services::weather;
use Services::sun;
use Services::dict;


$| = 1;
while (1) {

    my $weather = Services::weather::weather_check();
    my $time_of_day = Services::sun::time_of_day(Services::weather::get_coords());

    foreach my $key (Services::dict::return_keys()) {
        
        if (index($weather, $key) != -1) {
            
            system("gsettings set org.gnome.desktop.background picture-uri /usr/local/bin/weatherwalls_data/img/" .
            Services::dict::get_word($key) . "_" . $time_of_day . ".jpg");

            system("gsettings set org.gnome.desktop.background picture-uri-dark /usr/local/bin/weatherwalls_data/img/" .
            Services::dict::get_word($key) . "_" . $time_of_day . ".jpg");

        }

    }

    sleep(60 * 5);
}