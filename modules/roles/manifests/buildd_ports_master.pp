class roles::buildd_ports_master {
	ssl::service { 'buildd.debian-ports.org':
		notify => Service['apache2'],
	}
}
