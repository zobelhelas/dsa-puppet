define ssl::service($ensure = present, $tlsaport = 443) {
	$link_target = $ensure ? {
		present => link,
		absent  => absent,
		default => fail ( "Unknown ensure value: '$ensure'" ),
	}

	file { "/etc/munin/plugins/${name}":
		ensure  => $link_target,
		target  => "/usr/share/munin/plugins/${link}",
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}

	file { "/etc/ssl/debian/certs/$name.crt":
		source => "puppet:///modules/ssl/servicecerts/${name}.crt",
		notify => Exec['c_rehash /etc/ssl/debian/certs'],
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
