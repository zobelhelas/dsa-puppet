class roles::sso {
	ssl::service { 'sso.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
