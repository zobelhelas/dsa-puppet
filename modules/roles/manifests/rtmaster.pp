class roles::rtmaster {
	ssl::service { 'rt.debian.org':
		notify  => Exec['service apache2 reload'],
	}
}
