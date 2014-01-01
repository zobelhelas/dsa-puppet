class roles::release {
	ssl::service { 'release.debian.org':
		notify => Service['apache2'],
	}
}
