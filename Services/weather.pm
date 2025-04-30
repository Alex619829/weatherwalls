#!/usr/bin/perl
package Services::weather;

use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;
use WWW::ipinfo;
use JSON;
use Dotenv;
Dotenv->load('/var/lib/weatherwalls/.env');
use Env qw(OPENWEATHER_API_KEY);


sub weather_check {
    my $city = get_location();
    my $api_key = $OPENWEATHER_API_KEY;
    my $url = "http://api.openweathermap.org/data/2.5/weather?q=$city&lang=ru&appid=$api_key&units=metric";

    my $ua = LWP::UserAgent->new;
    my $res = $ua->get($url);

    if ($res->is_success) {
        my $data = decode_json($res->decoded_content);
        my $desc = $data->{weather}->[0]{description};
        return $desc;
    } else {
        warn "Ошибка запроса погоды: " . $res->status_line;
        return 'неизвестно';
    }
}


sub get_location {
    my $ipinfo = get_ipinfo();
    my $city = $ipinfo->{city};
    return $city;
}


sub get_coords {
    my $ipinfo = get_ipinfo();
    my $loc = $ipinfo->{loc};
    return $loc;
}

1;
