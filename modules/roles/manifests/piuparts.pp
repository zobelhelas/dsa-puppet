class roles::piuparts {
	ssl::service { 'piuparts.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
