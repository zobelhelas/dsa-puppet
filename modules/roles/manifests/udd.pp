class roles::udd {
	ssl::service { 'udd.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
