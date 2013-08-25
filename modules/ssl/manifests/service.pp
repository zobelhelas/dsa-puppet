define ssl::service($ensure = present, $tlsaport = 443, $notify = []) {
	$link_target = $ensure ? {
		present => link,
		absent  => absent,
		default => fail ( "Unknown ensure value: '$ensure'" ),
	}

	file { "/etc/ssl/debian/certs/$name.crt":
		source => "puppet:///modules/ssl/servicecerts/${name}.crt",
		notify => [ Exec['c_rehash /etc/ssl/debian/certs'], $notify ],
	}
	file { "/etc/ssl/debian/certs/$name.crt-chain":
		source => [ "puppet:///modules/ssl/servicecerts/${name}.crt-chain",  "puppet:///modules/ssl/empty" ],
		notify => [ Exec['c_rehash /etc/ssl/debian/certs'], $notify ],
		links => follow,
	}

	if $tlsaport > 0 {
		dnsextras::tlsa_record{ "tlsa-${tlsaport}":
			zone => 'debian.org',
			certfile => "/etc/puppet/modules/ssl/files/servicecerts/${name}.crt",
			port => $tlsaport,
			hostname => "$name",
		}
	}
}
