define ssl::service($ensure = present, $tlsaport = 443, $notify = []) {
	$link_target = $ensure ? {
		present => link,
		absent  => absent,
		default => fail ( "Unknown ensure value: '$ensure'" ),
	}

	file { "/etc/ssl/debian/certs/$name.crt":
		source => "puppet:///modules/ssl/servicecerts/${name}.crt",
		notify => [ Exec['refresh_debian_hashes'], $notify ],
	}
	file { "/etc/ssl/debian/certs/$name.crt-chain":
		source => [ "puppet:///modules/ssl/chains/${name}.crt", "puppet:///modules/ssl/servicecerts/${name}.crt" ],
		notify => [ Exec['refresh_debian_hashes'], $notify ],
		links  => follow,
	}
	file { "/etc/ssl/debian/certs/$name.crt-chained":
		content => template('ssl/chained.erb'),
		notify => [ Exec['refresh_debian_hashes'], $notify ],
	}

	if $tlsaport > 0 {
		dnsextras::tlsa_record{ "tlsa-${name}-${tlsaport}":
			zone     => 'debian.org',
			certfile => "/etc/puppet/modules/ssl/files/servicecerts/${name}.crt",
			port     => $tlsaport,
			hostname => "$name",
		}
	}
}
