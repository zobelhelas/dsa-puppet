class roles::snapshot {
	rsync::site { 'snapshot-farm':
		content => template('roles/snapshot/rsyncd.conf.erb'),
	}
}
