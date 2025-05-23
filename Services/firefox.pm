#!/usr/bin/perl
package Services::firefox;

use strict;
use warnings;
use JSON;
use File::Copy qw(copy);
use File::HomeDir;

my $query = "bonjourr";
my $ff_dir = File::HomeDir->my_home . "/.mozilla/firefox";

sub get_image_dir {
	open my $ini, '<', "$ff_dir/profiles.ini" or die "Can not open profiles.ini: $!";
	my $profile;
	while (<$ini>) {
		if (/^\[Install/) {
				while (<$ini>) {
					if (/^Default=(.+)$/) {
						$profile = $1;
						last;
					}
				}
			}
			last if $profile;
		}
	close $ini;

	die "❌ Failed to detect active profile\n" unless $profile;
	my $profile_dir = "$ff_dir/$profile";

	my $ext_file = "$profile_dir/extensions.json";
	open my $fh, '<', $ext_file or die "Failed to open $ext_file: $!";
	my $json_text = do { local $/; <$fh> };
	close $fh;

	my $data = decode_json($json_text);
	my ($found_id, $found_name);

	foreach my $addon (@{$data->{addons}}) {
		next unless ref $addon eq 'HASH';
		my $default_locale = $addon->{defaultLocale};
		next unless defined $default_locale && ref $default_locale eq 'HASH';
		my $name = $default_locale->{name};
		next unless defined $name;

		if (index(lc($name), lc($query)) != -1) {
			$found_id = $addon->{id};
			$found_name = $name;
			last;
		}
	}

	if ($found_id) {
		my $prefs_file = "$profile_dir/prefs.js";
		open my $prefs, '<', $prefs_file or die "Failed to open $prefs_file: $!";
		my $uuid;
		while (<$prefs>) {
			if (/user_pref\("extensions\.webextensions\.uuids",\s*"(.*?)"\)/) {
				my $json_str = $1;
				$json_str =~ s/\\"/"/g;
				my $uuids = decode_json($json_str);
				$uuid = $uuids->{$found_id};
				last;
			}
		}
		close $prefs;

		if ($uuid) {
			my $storage_path = "$profile_dir/storage/default/moz-extension+++$uuid";
			if (-d $storage_path) {
				# print "✅ Found Extension: $found_name\n";
				# print "🆔 ID: $found_id\n";
				# print "🔑 UUID: $uuid\n";
				# print "📁 Path: $storage_path\n";
				my $idb_path = File::Spec->catdir($storage_path, 'idb');

				if (-d $idb_path) {
					opendir my $dh, $idb_path or die "Failed to open $idb_path: $!";
					my @files_dirs = grep { /\.files$/ && -d File::Spec->catdir($idb_path, $_) } readdir($dh);
					closedir $dh;

					if (@files_dirs) {
						my $files_dir = File::Spec->catdir($idb_path, $files_dirs[0]);
						# print "✅ Found directory with images:\n📁 $files_dir\n";
						return $files_dir;
					} else {
						print "❌ Folder $idb_path does not have .files\n";
					}
				} else {
					print "❌ Folder idb not found: $idb_path\n";
				}
			} else {
				print "❗ UUID found ($uuid), but folder does not exist: $storage_path\n";
			}
		} else {
			print "❌ Failed to find UUID for ID $found_id in prefs.js\n";
		}
	} else {
		print "❌ Failed to find extension, which has '$query' in name\n";
	}

}

sub update_firefox_background {
    my ($img_path) = @_;

    my $dest_dir = get_image_dir();

    unless (-d $dest_dir) {
        die "❌ Destination dir '$dest_dir' not found.";
    }

    my $file1 = "$dest_dir/1";
    my $file2 = "$dest_dir/2";

    unless (copy($img_path, $file1)) {
        die "❌ Error copying to '$file1': $!";
    }

    unless (copy($img_path, $file2)) {
        die "❌ Error copiyng to '$file2': $!";
    }
}

1;
