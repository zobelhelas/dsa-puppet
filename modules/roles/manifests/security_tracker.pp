class roles::security_tracker {
	ssl::service { 'security-tracker.debian.org':
		notify => Service['apache2'],
	}
}
