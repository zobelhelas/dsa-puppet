class roles::keyring {
	rsync::site { 'keyring':
		source => 'puppet:///modules/roles/keyring/rsyncd.conf',
	}

	ssl::service { 'keyring.debian.org':
		notify => Service['apache2'],
		key => true,
	}
}
