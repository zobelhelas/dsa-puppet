class roles::sso {
	ssl::service { 'sso.debian.org':
		notify => Service['apache2'],
	}
}
