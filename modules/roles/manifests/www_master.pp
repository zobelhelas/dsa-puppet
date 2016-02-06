class roles::www_master {
	ssl::service { 'www-master.debian.org':
		notify => Service['apache2'],
		key => true,
	}
}
