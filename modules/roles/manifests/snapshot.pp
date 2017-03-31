class roles::snapshot {
	rsync::site_systemd { 'snapshot-farm':
		content => template('roles/snapshot/rsyncd.conf.erb'),
	}
}
