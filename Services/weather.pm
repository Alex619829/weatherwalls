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
use Env qw(YANDEX_API_KEY);

sub weather_check {
    my ($lat, $lon) = get_coords();  # Получаем координаты

    unless (defined $lat && defined $lon) {
        warn "Не удалось получить координаты";
        return 'неизвестно';
    }

    my $url = "https://weather.bonjourr.fr/?provider=auto&data=simple&lang=ru&unit=C&lat=$lat&lon=$lon";

    my $ua = LWP::UserAgent->new;
	$ua->default_header('User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36');
    my $res = $ua->get($url);

    if ($res->is_success) {
        my $data = decode_json($res->decoded_content);
        my $desc = $data->{now}->{description};
        return $desc;
    } else {
        warn "Ошибка запроса погоды: " . $res->status_line;
        return 'неизвестно';
    }
}

sub get_coords {
	# 🔐 Укажи свой API-ключ от Яндекса

	# Получаем список Wi-Fi сетей через nmcli
	my @wifi_raw = `nmcli -t -f BSSID,SIGNAL dev wifi list | head -n 5`;
	chomp @wifi_raw;

	my @wifi;
	foreach my $line (@wifi_raw) {
		$line =~ s/\\//g;  # Убираем экранированные символы
		my @parts = split(':', $line);

		# Последний элемент — сигнал, остальные составляют BSSID
		my $signal = pop @parts;
		my $bssid = join(':', @parts);

		# Проверка и добавление
		next unless $bssid && $signal =~ /^-?\d+$/;

		push @wifi, {
			bssid => $bssid,
			signal_strength => 0 - abs($signal)
		};
	}

	# Если Wi-Fi не найден — используем тестовую точку
	if (!@wifi) {
		push @wifi, { bssid => "AA:BB:CC:DD:EE:FF", signal_strength => -70 };
	}

	# Формируем JSON-пакет
	my $json_payload = encode_json({ wifi => \@wifi });

	# Создаём HTTP клиент
	my $ua = LWP::UserAgent->new;
	$ua->timeout(10);
	$ua->env_proxy;

	# Делаем POST-запрос
	my $res = $ua->post(
		"https://locator.api.maps.yandex.ru/v1/locate?apikey=$YANDEX_API_KEY",
		'Content-Type' => 'application/json',
		Content => $json_payload
	);

	# Обрабатываем результат
	if ($res->is_success) {
		my $data = decode_json($res->decoded_content);

		if ($data->{location} && $data->{location}->{point}) {
			return $data->{location}->{point}->{lat}, $data->{location}->{point}->{lon};
		} else {
			print "⚠️ Не удалось определить координаты: ", $res->decoded_content, "\n";
		}
	} else {
		die "❌ Ошибка запроса: " . $res->status_line . "\nОтвет: " . $res->decoded_content . "\n";
	}
}

1;
