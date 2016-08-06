class roles::release {
	ssl::service { 'release.debian.org':
		notify  => Exec['service apache2 reload'],
	}
}
