class roles::keyring {
	rsync::site_systemd { 'keyring':
		source  => 'puppet:///modules/roles/keyring/rsyncd.conf',
		sslname => 'keyring.debian.org',
	}

	ssl::service { 'keyring.debian.org':
		notify   => Exec['service apache2 reload'],
		key      => true,
		tlsaport => [443, 1873],
	}
}
