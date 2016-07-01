class roles::wiki {
	ssl::service { 'wiki.debian.org':
		notify => Service['apache2'],
		key => true,
	}
	rsync::site { 'wiki':
		source => 'puppet:///modules/roles/wiki/rsyncd.conf',
	}
}
