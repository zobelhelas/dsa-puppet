class roles::rtmaster {
	ssl::service { 'rt.debian.org':
		notify => Service['apache2'],
	}
}
