class roles::wiki {
	ssl::service { 'wiki.debian.org':
		notify => Service['apache2'],
		tlsaport => [],
	}
	rsync::site { 'wiki':
		source => 'puppet:///modules/roles/wiki/rsyncd.conf',
	}
}
