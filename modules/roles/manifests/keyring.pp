class roles::keyring {
	rsync::site { 'keyring':
		source => 'puppet:///modules/roles/keyring/rsyncd.conf',
	}

	ssl::service { 'keyring.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
