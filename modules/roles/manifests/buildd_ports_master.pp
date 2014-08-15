class roles::buildd_master {
	ssl::service { 'buildd.debian-ports.org':
		notify => Service['apache2'],
	}
}
