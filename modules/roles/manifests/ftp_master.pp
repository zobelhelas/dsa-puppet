class roles::ftp_master {
	rsync::site { 'dakmaster':
		source      => 'puppet:///modules/roles/dakmaster/rsyncd.conf',
		# Needs to be at least number of direct mirrors plus some spare
		max_clients => 50,
		sslname     => 'ftp-master.debian.org',
	}

	ssl::service { 'ftp-master.debian.org':
		notify   => Exec['service apache2 reload'],
		key      => true,
		tlsaport => [443, 1873],
	}
}
