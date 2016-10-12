class roles::contributors {
	ssl::service { 'contributors.debian.org':
		notify  => Exec['service apache2 reload'],
		tlsaport => 0,
	}
}
