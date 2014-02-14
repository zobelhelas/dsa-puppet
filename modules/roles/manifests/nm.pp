class roles::nm {
	ssl::service { 'nm.debian.org':
		notify => Service['apache2'],
	}
}
