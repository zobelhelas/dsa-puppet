class roles::archive_master {
	$sslname = 'archive-master.debian.org'

	rsync::site { 'archive_master':
		source        => 'puppet:///modules/roles/archive_master/rsyncd.conf',
		max_clients   => 100,
		sslname       => $sslname,
	}

	ssl::service { $sslname:
		key => true,
		tlsaport => [],
	}
}