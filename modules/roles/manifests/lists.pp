class roles::lists {
	ssl::service { 'lists.debian.org':
		notify => Service['apache2'],
	}
}
