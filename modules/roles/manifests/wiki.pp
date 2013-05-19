class roles::wiki {
	rsync::site { 'wiki':
		source => 'puppet:///modules/roles/wiki/rsyncd.conf',
	}
}
