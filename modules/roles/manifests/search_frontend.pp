class roles::search_frontend {
	ssl::service { 'search.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
