define ssl::service($ensure = present, $tlsaport = 443, $notify = [], $key = false) {
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
	if $key {
		file { "/etc/ssl/private/$name.key":
			mode   => '0440',
			group => 'ssl-cert',
			source => [ "puppet:///modules/ssl/keys/${name}.crt", "puppet:///modules/ssl/from-letsencrypt/${name}.key" ],
			notify => [ $notify ],
			links  => follow,
		}
	}

	if $tlsaport > 0 {
		dnsextras::tlsa_record{ "tlsa-${name}-${tlsaport}":
			zone     => 'debian.org',
			certfile => [ "/etc/puppet/modules/ssl/files/servicecerts/${name}.crt", "/etc/puppet/modules/ssl/files/from-letsencrypt/${name}.crt" ],
			port     => $tlsaport,
			hostname => "$name",
		}
	}
}
