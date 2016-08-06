class roles::www_master {
	ssl::service { 'www-master.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
