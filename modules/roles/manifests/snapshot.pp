class roles::snapshot {
	rsync::site { 'snapshot-farm':
		content => template('roles/snapshot/rsync.conf.erb'),
	}
}
