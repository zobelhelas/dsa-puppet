class roles::tracker {
	ssl::service { 'tracker.debian.org':
		notify => Service['apache2'],
	}
}
