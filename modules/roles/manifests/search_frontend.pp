class roles::search_frontend {
	ssl::service { 'search.debian.org':
		notify => Service['apache2'],
		tlsaport => 0,
	}
}
