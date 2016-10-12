class roles::nm {
	ssl::service { 'nm.debian.org':
		notify  => Exec['service apache2 reload'],
		tlsaport => 0,
	}
}
