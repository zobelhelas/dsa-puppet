class roles::tracker {
	ssl::service { 'tracker.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
