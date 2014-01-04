class ssl {

	$cacert = 'mozilla/UTN_USERFirst_Hardware_Root_CA.crt'
	$caconf = '/etc/ca-certificates.conf'

	package { 'openssl':
		ensure   => installed,
	}
	package { 'ssl-cert':
		ensure   => installed,
	}
	package { 'ca-certificates':
		ensure   => installed,
	}

	file { '/etc/ssl/servicecerts':
		ensure   => directory,
		source   => 'puppet:///modules/ssl/servicecerts/',
		mode     => '0644',
		purge    => true,
		recurse  => true,
		force    => true,
		notify   => Exec['refresh_debian_links'],
	}
	file { '/etc/ssl/debian':
		ensure   => directory,
		source   => 'puppet:///files/empty/',
		mode     => '0644',
		purge    => true,
		recurse  => true,
		force    => true,
	}
	file { '/etc/ssl/debian/certs':
		ensure  => directory,
		mode    => '0755',
	}
	file { '/etc/ssl/debian/crls':
		ensure  => directory,
		mode    => '0755',
	}
	file { '/etc/ssl/debian/keys':
		ensure  => directory,
		mode    => '0750',
		group   => ssl-cert,
		require => Package['ssl-cert'],
	}
	file { '/etc/ssl/debian/certs/thishost.crt':
		source  => "puppet:///modules/ssl/clientcerts/${::fqdn}.client.crt",
		notify  => Exec['refresh_debian_hashes'],
	}
	file { '/etc/ssl/debian/keys/thishost.key':
		source  => "puppet:///modules/ssl/clientcerts/${::fqdn}.key",
		mode    => '0440',
		group   => ssl-cert,
		require => Package['ssl-cert'],
	}
	file { '/etc/ssl/debian/certs/ca.crt':
		source  => 'puppet:///modules/ssl/clientcerts/ca.crt',
		notify  => Exec['refresh_debian_hashes'],
	}
	file { '/etc/ssl/debian/crls/ca.crl':
		source  => 'puppet:///modules/ssl/clientcerts/ca.crl',
	}
	file { '/etc/ssl/debian/certs/thishost-server.crt':
		source  => "puppet:///modules/exim/certs/${::fqdn}.crt",
		notify  => Exec['refresh_debian_hashes'],
	}
	file { '/etc/ssl/debian/keys/thishost-server.key':
		source  => "puppet:///modules/exim/certs/${::fqdn}.key",
		mode    => '0440',
		group   => ssl-cert,
		require => Package['ssl-cert'],
	}

	exec { 'refresh_debian_links':
		command     => 'cp -f -s ../servicecerts/* .',
		cwd         => '/etc/ssl/certs',
		refreshonly => true,
		notify      => Exec['delete_unused_links'],
	}
	exec { 'delete_unused_links':
		command     => 'find -L . -mindepth 1 -maxdepth 1 -type l -delete',
		cwd         => '/etc/ssl/certs',
		refreshonly => true,
		notify      => Exec['refresh_normal_hashes'], # see NOTE 1
	}
	exec { 'modify_configuration':
		command     => "sed -i -e 's#!${cacert}#${cacert}' ${caconf}",
		onlyif      => "grep -Fqx '!${cacert}' ${caconf}",
		notify      => Exec['refresh_normal_hashes'],
		require     => Package['ca-certificates'],
	}
	exec { 'refresh_debian_hashes':
		command     => '/usr/bin/c_rehash .',
		cwd         => '/etc/ssl/debian/certs',
		refreshonly => true,
		require     => Package['openssl']
	}
	exec { 'refresh_normal_hashes':
		# NOTE 1: always use update-ca-certificates to manage hashes in
		#         /etc/ssl/certs otherwise /etc/ssl/ca-certificates.crt will
		#         get a hash overriding the hash that would have been generated
		#         for another certificate ... which is problem, comrade
		# NOTE 2: always ask update-ca-certificates to freshen (-f) the links
		command     => '/usr/sbin/update-ca-certificates -f',
		refreshonly => true,
		require     => Package['ca-certificates'],
	}

}
