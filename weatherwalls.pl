#!/usr/bin/perl
use strict;
use warnings;
use File::chdir;

my $signal = $ARGV[0];
my $firefox_support = $ARGV[1];  # can be undef or 'firefox'

# Valid values for the second argument
my %valid_flags = (
    ""        => 1,  # empty value is allowed
    "firefox" => 1,
);

# Check if no signal is provided
if (!defined $signal) {
    print_usage();
    exit;
}

# Validate signal
if ($signal ne 'on' && $signal ne 'off') {
    print "❌ Error: unknown command '$signal'\n";
    print_usage();
    exit;
}

# Validate the second argument
if (defined $firefox_support && !$valid_flags{$firefox_support}) {
    print "❌ Error: unknown flag '$firefox_support'\n";
    print_usage();
    exit;
}

# Main logic
if ($signal eq 'on') {

    my $pid = `pgrep -f weatherw.pl`;

    if ($pid eq '') {
        chdir("/var/lib/weatherwalls");

        my $cmd = "perl weatherw.pl";
        $cmd .= " firefox" if defined($firefox_support) && $firefox_support eq "firefox";
        system("$cmd &");

        print("✅ Process started\n");
    } else {
        print("ℹ️  Process is already running\n");
    }

} elsif ($signal eq 'off') {

    my $pid = `pgrep -f weatherw.pl`;

    if ($pid eq '') {
        print("ℹ️  Process is not running\n");
    } else {
        system("kill $pid");
        print("🛑 Process stopped\n");
    }

}

# Usage help
sub print_usage {
    print <<'USAGE';

📝 Usage:
  ./weatherwalls on [firefox]   - Start the wallpaper daemon + optionally enable Firefox support
  ./weatherwalls off            - Stop the process

  Valid optional flag:
    firefox  - enables wallpaper syncing with Firefox

USAGE
}

