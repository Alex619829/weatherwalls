#!/usr/bin/perl
package Services::sun;

use strict;
use warnings;
use DateTime;
use DateTime::Event::Sunrise;
use POSIX qw/strftime/;
use Time::Local;


sub time_of_day {

    my ($coords) = @_;
    my @coordsArray = split /,/, $coords, 2;

    my $latitude = $coordsArray[0];
    my $longitude = $coordsArray[1];

    my $date = DateTime->now(time_zone => 'local');

    my $sunrise = DateTime::Event::Sunrise->new(
        longitude => $longitude,
        latitude  => $latitude,
        altitude  => '-0.833',   # Алгоритм учитывает стандартную атмосферную рефракцию
    );

    my $sunrise_time_string = $sunrise->sunrise_datetime($date);
    my $sunset_time_string  = $sunrise->sunset_datetime($date);

    $sunrise_time_string =~ s/T/ /g;
    $sunset_time_string =~ s/T/ /g;

    my ($year_sunrise, $mon_sunrise, $day_sunrise, $hour_sunrise, $min_sunrise, $sec_sunrise) = split(/[\s\-:]+/, $sunrise_time_string);
    my ($year_sunset, $mon_sunset, $day_sunset, $hour_sunset, $min_sunset, $sec_sunset) = split(/[\s\-:]+/, $sunset_time_string);

    my $sunrise_time = timelocal($sec_sunrise,$min_sunrise,$hour_sunrise,$day_sunrise,$mon_sunrise-1,$year_sunrise);
    my $sunset_time = timelocal($sec_sunset,$min_sunset,$hour_sunset,$day_sunset,$mon_sunset-1,$year_sunset);

    day_or_night_definition($sunrise_time, $sunset_time);

}


sub day_or_night_definition {

    my ($sunrise_time, $sunset_time) = @_;

    my $current_time = get_current_time();
    
    if ($current_time >= $sunrise_time && $current_time <= $sunset_time) {
        return 'day';
    } elsif ($current_time >= $sunset_time) {
        return 'night';
    }

}


sub get_current_time {

    my $timestamp = time;
    return $timestamp;

}

1;
