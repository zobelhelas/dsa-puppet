class ssl {

	package {
		'openssl':
			ensure => installed,
			;
		'ssl-cert':
			ensure => installed,
			;
		'ca-certificates':
			ensure => installed,
			;
	}

	file { '/etc/ssl/servicecerts':
		ensure  => directory,
		mode    => '0755',
		purge   => true,
		recurse => true,
		force   => true,
		source  => 'puppet:///modules/ssl/servicecerts/',
		notify  => Exec['make_new_service_links']
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
		require => Package['ssl-cert'],
	}
	file { '/etc/ssl/debian/certs/thishost.crt':
		source => "puppet:///modules/ssl/clientcerts/${::fqdn}.client.crt",
		notify => Exec['c_rehash /etc/ssl/debian/certs'],
	}
	file { '/etc/ssl/debian/keys/thishost.key':
		source => "puppet:///modules/ssl/clientcerts/${::fqdn}.key",
		mode   => '0440',
		group   => ssl-cert,
		require => Package['ssl-cert'],
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
		mode    => '0440',
		group   => ssl-cert,
		require => Package['ssl-cert'],
	}

	exec { 'make_new_service_links':
		command     => 'cp -f --symbolic-link ../servicecerts/* .',
		cwd         => '/etc/ssl/certs',
		refreshonly => true,
		notify      => Exec['cleanup_dead_links']
	}

	exec { 'cleanup_dead_links':
		command     => 'find -L /etc/ssl/certs -mindepth 1 -maxdepth 1 -type l -delete',
		refreshonly => true,
		notify      => Exec['c_rehash /etc/ssl/certs']
	}

	exec { 'c_rehash /etc/ssl/certs':
		refreshonly => true,
	}

	exec { 'c_rehash /etc/ssl/debian/certs':
		refreshonly => true,
	}

	exec { 'modify_ca_certificates_conf':
		command     => 'sed -i -e \'s#!mozilla/UTN_USERFirst_Hardware_Root_CA.crt#mozilla/UTN_USERFirst_Hardware_Root_CA.crt#\' /etc/ca-certificates.conf',
		cwd         => '/etc/ssl/certs',
		onlyif      => 'grep -Fqx \'!mozilla/UTN_USERFirst_Hardware_Root_CA.crt\' /etc/ca-certificates.conf',
		notify	    => Exec['update_ca_certificates']
	}
	exec { 'update_ca_certificates':
		command     => '/usr/sbin/update-ca-certificates',
		cwd         => '/etc/ssl/certs',
		refreshonly => true
	}

}
