class ssl {

	package { 'openssl':
		ensure => installed
	}

	file { '/etc/ssl/debian':
		ensure  => directory,
		mode    => '0755',
		purge   => true,
		recurse => true,
		force   => true,
		source  => 'puppet:///files/empty/'
	}
	file { '/etc/ssl/debian/certs':
		ensure => directory,
		mode   => '0755',
	}
	file { '/etc/ssl/debian/crls':
		ensure => directory,
		mode   => '0755',
	}
	file { '/etc/ssl/debian/keys':
		ensure => directory,
		group  => ssl-cert,
		mode   => '0750',
	}
	file { '/etc/ssl/debian/certs/thishost.crt':
		source => "puppet:///modules/ssl/clientcerts/${::fqdn}.client.crt",
		notify => Exec['c_rehash /etc/ssl/debian/certs'],
	}
	file { '/etc/ssl/debian/keys/thishost.key':
		source => "puppet:///modules/ssl/clientcerts/${::fqdn}.key",
		mode   => '0440'
	}
	file { '/etc/ssl/debian/certs/ca.crt':
		source => 'puppet:///modules/ssl/clientcerts/ca.crt',
		notify => Exec['c_rehash /etc/ssl/debian/certs'],
	}
	file { '/etc/ssl/debian/crls/ca.crl':
		source  => 'puppet:///modules/ssl/clientcerts/ca.crl',
	}

	file { '/etc/ssl/debian/certs/thishost-server.crt':
		source  => "puppet:///modules/exim/certs/${::fqdn}.crt",
		notify => Exec['c_rehash /etc/ssl/debian/certs'],
	}
	file { '/etc/ssl/debian/keys/thishost-server.key':
		source  => "puppet:///modules/exim/certs/${::fqdn}.key",
		group   => ssl-cert,
		mode    => '0440',
	}

	exec { 'c_rehash /etc/ssl/debian/certs':
		refreshonly => true,
	}
}
