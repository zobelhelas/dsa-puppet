class roles::security_tracker {
	ssl::service { 'security-tracker.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
