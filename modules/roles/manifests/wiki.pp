class roles::wiki {
	ssl::service { 'wiki.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
	rsync::site { 'wiki':
		source => 'puppet:///modules/roles/wiki/rsyncd.conf',
	}
}
