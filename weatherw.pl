#!/usr/bin/perl
use strict;
use warnings;
use open qw(:std :utf8);
use Encode qw(decode);
use lib '/var/lib/weatherwalls';
use Services::weather;
use Services::sun;
use Services::dict;

my $log_file = "$ENV{HOME}/weatherwalls.log";

sub log_msg {
    my ($msg) = @_;
    open my $log_fh, '>>', $log_file or die "Cannot open log file: $!";
    my $timestamp = localtime();
    print $log_fh "[$timestamp] $msg\n";
    close $log_fh;
}

$| = 1;
log_msg("WeatherWalls daemon started.");

while (1) {
    eval {
        log_msg("Starting iteration...");

        my $weather = Services::weather::weather_check();
        my ($lat, $lon) = Services::weather::get_coords();
        log_msg("Coordinates: lat=$lat, lon=$lon");

        my $time_of_day = Services::sun::time_of_day($lat, $lon);

        log_msg("Weather: $weather");
        log_msg("Time of day: $time_of_day");

        my $weather_code = Services::dict::get_word($weather);

        if ($weather_code eq 'unknown') {
            log_msg("Unrecognized weather condition: '$weather'. Skipping wallpaper change.");
        }
        elsif (!$time_of_day) {
            log_msg("Could not determine time of day. Skipping wallpaper change.");
        }
        else {
            my $image = $weather_code . "_" . $time_of_day . ".jpg";
            my $img_path = "/var/lib/weatherwalls/img/$image";

            log_msg("Setting wallpaper to: $img_path");

            system("gsettings set org.gnome.desktop.background picture-uri file://$img_path");
            system("gsettings set org.gnome.desktop.background picture-uri-dark file://$img_path");
        }

        log_msg("Iteration complete.");
    };
    if ($@) {
        log_msg("Error occurred: $@");
    }

    sleep(60 * 5);
}

