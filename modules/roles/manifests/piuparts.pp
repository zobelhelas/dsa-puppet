class roles::piuparts {
	ssl::service { 'piuparts.debian.org':
		notify => Service['apache2'],
		tlsaport => 0,
	}
}
