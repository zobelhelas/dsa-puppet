class roles::contributors {
	ssl::service { 'contributors.debian.org':
		notify => Service['apache2'],
	}
}
