class roles::wiki {
	ssl::service { 'wiki.debian.org': }
	rsync::site { 'wiki':
		source => 'puppet:///modules/roles/wiki/rsyncd.conf',
	}
}
