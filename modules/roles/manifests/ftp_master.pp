class roles::ftp_master {
	rsync::site_systemd { 'dakmaster':
		source      => 'puppet:///modules/roles/dakmaster/rsyncd.conf',
		max_clients => 100,
		sslname     => 'ftp-master.debian.org',
	}

	ssl::service { 'ftp-master.debian.org':
		notify   => Exec['service apache2 reload'],
		key      => true,
		tlsaport => [443, 1873],
	}
}
