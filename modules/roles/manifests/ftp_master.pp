class roles::ftp_master {
	rsync::site { 'dakmaster':
		source        => 'puppet:///modules/roles/dakmaster/rsyncd.conf',
		max_clients   => 100,
		sslname       => 'ftp-master.debian.org',
	}

	ssl::service { 'ftp-master.debian.org':
		notify  => Exec['service apache2 reload'],
	}
}
