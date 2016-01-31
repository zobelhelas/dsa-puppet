define ssl::service($ensure = present, $tlsaport = 443, $notify = []) {
	$link_target = $ensure ? {
		present => link,
		absent  => absent,
		default => fail ( "Unknown ensure value: '$ensure'" ),
	}

	file { "/etc/ssl/debian/certs/$name.crt":
		source => [ "puppet:///modules/ssl/servicecerts/${name}.crt", "puppet:///modules/ssl/from-letsencrypt/${name}.crt" ],
		notify => [ Exec['refresh_debian_hashes'], $notify ],
	}
	file { "/etc/ssl/debian/certs/$name.crt-chain":
		source => [ "puppet:///modules/ssl/chains/${name}.crt", "puppet:///modules/ssl/servicecerts/${name}.crt", "puppet:///modules/ssl/from-letsencrypt/${name}.crt-chain" ],
		notify => [ $notify ],
		links  => follow,
	}
	file { "/etc/ssl/debian/certs/$name.crt-chained":
		content => template('ssl/chained.erb'),
		notify => [ $notify ],
	}

	if $tlsaport > 0 {
		dnsextras::tlsa_record{ "tlsa-${name}-${tlsaport}":
			zone     => 'debian.org',
			certfile => [ "puppet:///modules/ssl/servicecerts/${name}.crt", "puppet:///modules/ssl/from-letsencrypt/${name}.crt" ],
			port     => $tlsaport,
			hostname => "$name",
		}
	}
}
