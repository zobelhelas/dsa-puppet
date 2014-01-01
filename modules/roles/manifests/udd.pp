class roles::udd {
	ssl::service { 'udd.debian.org':
		notify => Service['apache2'],
	}
}
