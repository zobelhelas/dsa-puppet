class roles::ftp_master {

	rsync::site { 'dakmaster':
		source        => 'puppet:///modules/roles/dakmaster/rsyncd.conf',
		max_clients => 100,
	}
}
