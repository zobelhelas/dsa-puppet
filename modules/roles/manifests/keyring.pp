class roles::keyring {
	rsync::site { 'keyring':
		source => 'puppet:///modules/roles/keyring/rsyncd.conf',
	}
}
