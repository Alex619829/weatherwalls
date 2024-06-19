#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use Services::weather;
use Services::sun;
use Services::dict;


$| = 1;
while (1) {

    my $weather = Services::weather::weather_check();
    my $time_of_day = Services::sun::time_of_day(Services::weather::get_coords());
    print(lc($weather));
    foreach my $key (Services::dict::return_keys()) {
        
        if (index($weather, $key) != -1) {

            print("gsettings set org.gnome.desktop.background picture-uri ~/Perl_Projects/Weather/img/" .
            Services::dict::get_word($key) . "_" . $time_of_day . ".jpg");
            
            system("gsettings set org.gnome.desktop.background picture-uri ~/Perl_Projects/Weather/img/" .
            Services::dict::get_word($key) . "_" . $time_of_day . ".jpg");

            system("gsettings set org.gnome.desktop.background picture-uri-dark ~/Perl_Projects/Weather/img/" .
            Services::dict::get_word($key) . "_" . $time_of_day . ".jpg");

        }

    }

    sleep(60);
}