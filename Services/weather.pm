#!/usr/bin/perl
package Services::weather;


use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;
use WWW::ipinfo;


sub weather_check {

    my $city = get_location() . "  погода";

    my $ua = LWP::UserAgent->new;
    $ua->agent('Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.952 YaBrowser/24.4.1.952 (beta) Yowser/2.5 Safari/537.36');

    my $res = $ua->get("https://www.google.com/search?q=$city&oq=$city&aqs=chrome.0.35i39l2j0l4j46j69i60.6128j1j7&sourceid=chrome&ie=UTF-8");

    my $content = $res->content;
    my $tree = HTML::TreeBuilder->new_from_content($content);

    my $precipitation = $tree->look_down(_tag => 'span', id => 'wob_dc')->as_text;
    $tree->delete;

    return $precipitation;

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
