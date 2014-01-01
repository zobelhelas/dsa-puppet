class roles::dbmaster {
	ssl::service { 'db.debian.org':
		notify => Service['apache2'],
	}
}
