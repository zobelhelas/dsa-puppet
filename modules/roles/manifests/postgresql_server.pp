class roles::postgresql_server {
	file { "/usr/local/bin/pg-backup-file":
		mode    => 555,
		source  => "puppet:///modules/roles/postgresql_server/pg-backup-file",
	}
	file { "/usr/local/bin/pg-receive-file-from-backup":
		mode    => 555,
		source  => "puppet:///modules/roles/postgresql_server/pg-receive-file-from-backup",
	}
	file { "/etc/dsa/pg-backup-file.conf":
		content => template('roles/postgresql_server/pg-backup-file.conf.erb'),
	}
}
