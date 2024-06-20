#!/usr/bin/perl
package Services::dict;

use strict;
use warnings;


my %dictionary = (
    'солнечно' => 'clear',
    'Солнечно' => 'clear',
    'ясно' => 'clear',
    'Ясно' => 'clear',
    'облачно' => 'cloudy',
    'Облачно' => 'cloudy',
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
    return $dictionary{$word};
}


sub return_keys {
    return keys %dictionary;
}

1;
