class postgres::backup_server {
	package { 'postgresql-client-9.1':
		ensure => installed
	}

	file { '/usr/local/bin/postgres-make-base-backups':
		source => 'puppet:///modules/postgres/backup_server/postgres-make-base-backups',
		mode   => '0555',
	}
	file { '/etc/cron.d/puppet-postgres-make-base-backups':
		content  => "20 0 * * 6 debbackup chronic /usr/local/bin/postgres-make-base-backups\n",
	}
}
