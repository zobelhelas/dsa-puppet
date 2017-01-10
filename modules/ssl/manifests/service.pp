define ssl::service($ensure = present, $tlsaport = 443, $notify = [], $key = false) {
	$tlsaports = any2array($tlsaport)

	if ($ensure == "ifstatic") {
		$ssl_ensure = has_static_component($name) ? {
			true => "present",
			false => "absent"
		}
	} else {
		$ssl_ensure = $ensure
	}

	file { "/etc/ssl/debian/certs/$name.crt":
		ensure => $ssl_ensure,
		source => [ "puppet:///modules/ssl/servicecerts/${name}.crt", "puppet:///modules/ssl/from-letsencrypt/${name}.crt" ],
		notify => [ Exec['refresh_debian_hashes'], $notify ],
	}
	file { "/etc/ssl/debian/certs/$name.crt-chain":
		ensure => $ssl_ensure,
		source => [ "puppet:///modules/ssl/chains/${name}.crt", "puppet:///modules/ssl/servicecerts/${name}.crt", "puppet:///modules/ssl/from-letsencrypt/${name}.crt-chain" ],
		notify => [ $notify ],
		links  => follow,
	}
	file { "/etc/ssl/debian/certs/$name.crt-chained":
		ensure => $ssl_ensure,
		content => template('ssl/chained.erb'),
		notify => [ $notify ],
	}
	if $key {
		file { "/etc/ssl/private/$name.key":
			ensure => $ssl_ensure,
			mode   => '0440',
			group => 'ssl-cert',
			source => [ "puppet:///modules/ssl/keys/${name}.crt", "puppet:///modules/ssl/from-letsencrypt/${name}.key" ],
			notify => [ $notify ],
			links  => follow,
		}

		file { "/etc/ssl/private/$name.key-certchain":
			ensure => $ssl_ensure,
			mode   => '0440',
			group => 'ssl-cert',
			content => template('ssl/key-chained.erb'),
			notify => [ $notify ],
			links  => follow,
		}
	}

	if (size($tlsaports) > 0 and $ssl_ensure == "present") {
		$portlist = join($tlsaports, "-")
		dnsextras::tlsa_record{ "tlsa-${name}-${portlist}":
			zone     => 'debian.org',
			certfile => [ "/etc/puppet/modules/ssl/files/servicecerts/${name}.crt", "/etc/puppet/modules/ssl/files/from-letsencrypt/${name}.crt" ],
			port     => $tlsaport,
			hostname => "$name",
		}
	}
}
