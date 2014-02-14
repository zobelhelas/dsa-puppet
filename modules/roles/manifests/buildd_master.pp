class roles::buildd_master {
	ssl::service { 'buildd.debian.org':
		notify => Service['apache2'],
	}
}
