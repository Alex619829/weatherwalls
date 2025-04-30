#!/usr/bin/perl
package Services::dict;

use strict;
use warnings;
use utf8;


my %dictionary = (
    'солнечно' => 'clear',
    'Солнечно' => 'clear',
    'ясно' => 'clear',
    'Ясно' => 'clear',
    'облачно' => 'cloudy',
    'Облачно' => 'cloudy',
	'Пасмурно' => 'cloudy',
	'пасмурно' => 'cloudy',
    'дождь' => 'rainy',
    'Дождь' => 'rainy',
    'морось' => 'rainy',
    'Морось' => 'rainy',
    'грозы' => 'stormy',
    'Грозы' => 'stormy',
    'гроза' => 'stormy',
    'Гроза' => 'stormy',
    'снег' => 'snowy',
    'Снег' => 'snowy',
    'снегопад' => 'snowy',
    'Снегопад' => 'snowy',
);


sub get_word {
    my ($word) = @_;

    foreach my $key (keys %dictionary) {
        if (index(lc($word), lc($key)) != -1) {
            return $dictionary{$key};
        }
    }

    return 'unknown';
}


sub return_keys {
    return keys %dictionary;
}

1;
