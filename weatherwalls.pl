#!/usr/bin/perl
use File::chdir;


my $signal = $ARGV[0];

if ($signal eq "on") {

    my $pid = `pgrep -f weatherw.pl`;

    if ($pid eq '') {
        chdir("/var/lib/weatherwalls");
        system("perl weatherw.pl &");
        print("OK\n");
    } else {
        print("Process is already running\n");
    }

} elsif ($signal eq "off") {

    my $pid = `pgrep -f weatherw.pl`;
    
    if ($pid eq '') {
        print("Process is not running\n");
    } else {
        system("kill $pid");
        print("Process stopped\n");
    }

} elsif ($signal eq undef) {
    print("Use keys on/off after 'weatherwalls'\n");
} else {
    print("Undefined key '$signal'! Use keys on/off\n");
}
