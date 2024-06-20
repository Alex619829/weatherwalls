#!/usr/bin/perl
package Services::dict;

use strict;
use warnings;


my %dictionary = (
    'солнечно' => 'clear',
    'ясно' => 'clear',
    'облачно' => 'cloudy',
    'дождь' => 'rainy',
    'морось' => 'rainy',
    'грозы' => 'stormy',
    'гроза' => 'stormy',
    'снег' => 'snowy',
    'снегопад' => 'snowy',
);


sub get_word {
    my ($word) = @_;
    return $dictionary{$word};
}


sub return_keys {
    return keys %dictionary;
}

1;
