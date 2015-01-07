class ssl {
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

	file { '/etc/ca-certificates.conf':
		content => "# This file is under puppet control\n# Only debian.org service certs are trusted, see /etc/ssl/certs/README",
		notify  => Exec['refresh_normal_hashes'],
	}
	file { '/etc/ca-certificates-debian.conf':
		mode    => '0444',
		content => "# This file is under puppet control\n# Only the CAs for debian.org are trusted, see /etc/ssl/ca-debian/README\nmozilla/AddTrust_External_Root.crt",
		notify  => Exec['refresh_ca_debian_hashes'],
	}
	file { '/etc/ca-certificates-global.conf':
		content => "# This file is under puppet control\n# All CAs are trusted, see /etc/ssl/ca-global/README",
		notify  => Exec['refresh_ca_global_hashes'],
	}

	file { '/etc/apt/apt.conf.d/99dsa-ssl-ca-global':
		mode   => '0444',
		source => 'puppet:///modules/ssl/apt.conf.d-99dsa-ssl-ca-global',
	}

	file { '/etc/ssl/certs/ssl-cert-snakeoil.pem':
		ensure => absent,
		notify => Exec['refresh_normal_hashes'],
	}
	file { '/etc/ssl/private/ssl-cert-snakeoil.key':
		ensure => absent,
	}

	file { '/etc/ssl/servicecerts':
		ensure   => link,
		purge    => true,
		force    => true,
		target   => '/usr/local/share/ca-certificates/debian.org',
		notify   => Exec['retire_debian_links'],
	}

	file { '/usr/local/share/ca-certificates/debian.org':
		ensure   => directory,
		source   => 'puppet:///modules/ssl/servicecerts/',
		mode     => '0644', # this works; otherwise all files are +x
		purge    => true,
		recurse  => true,
		force    => true,
		notify   => Exec['refresh_normal_hashes'],
	}
	file { '/etc/ssl/certs/README':
		mode   => '0444',
		source => 'puppet:///modules/ssl/README.certs',
	}
	file { '/etc/ssl/ca-debian':
		ensure => directory,
		mode   => '0755',
	}
	file { '/etc/ssl/ca-debian/README':
		mode   => '0444',
		source => 'puppet:///modules/ssl/README.ca-debian',
	}
	file { '/etc/ssl/ca-global':
		ensure => directory,
		mode   => '0755',
	}
	file { '/etc/ssl/ca-debian/README':
		mode   => '0444',
		source => 'puppet:///modules/ssl/README.ca-global',
	}
	file { '/etc/ssl/debian':
		ensure   => directory,
		source   => 'puppet:///files/empty/',
		mode     => '0644', # this works; otherwise all files are +x
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

	file { '/usr/local/sbin/update-ca-certificates-dsa':
		mode   => '0555',
		source => 'puppet:///modules/ssl/update-ca-certificates-dsa',
	}

	exec { 'retire_debian_links':
		command     => 'find -lname "../servicecerts/*" -exec rm {} +',
		cwd         => '/etc/ssl/certs',
		refreshonly => true,
		notify      => Exec['refresh_normal_hashes'],
	}
	exec { 'refresh_debian_hashes':
		command     => 'c_rehash /etc/ssl/debian/certs',
		refreshonly => true,
		require     => Package['openssl'],
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
	exec { 'refresh_ca_debian_hashes':
		command     => '/usr/local/sbin/update-ca-certificates-dsa --fresh --certsconf /etc/ca-certificates-debian.conf --localcertsdir /dev/null --etccertsdir /etc/ssl/ca-debian --hooksdir /dev/null',
		refreshonly => true,
		require     => [
			Package['ca-certificates'],
			File['/etc/ssl/ca-debian'],
			File['/etc/ca-certificates-debian.conf'],
			File['/usr/local/sbin/update-ca-certificates-dsa'],
		]
	}
	exec { 'refresh_ca_global_hashes':
		command     => '/usr/local/sbin/update-ca-certificates-dsa --fresh --default --certsconf /etc/ca-certificates-global.conf --etccertsdir /etc/ssl/ca-global --hooksdir /dev/null',
		refreshonly => true,
		require     => [
			Package['ca-certificates'],
			File['/etc/ssl/ca-global'],
			File['/etc/ca-certificates-global.conf'],
			File['/usr/local/sbin/update-ca-certificates-dsa'],
		]
	}

}
