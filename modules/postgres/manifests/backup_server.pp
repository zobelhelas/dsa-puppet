class postgres::backup_server {
	package { 'postgresql-client-9.1':
		ensure => installed
	}
	package { 'postgresql-client-9.4':
		ensure => installed
	}

	file { '/usr/local/bin/postgres-make-base-backups':
		content => template('postgres/postgres-make-base-backups.erb'),
		mode   => '0555',
	}
	if $::hostname in [backuphost] {
		file { '/etc/cron.d/puppet-postgres-make-base-backups':
			content  => "20 1 * * 0 debbackup chronic /usr/local/bin/postgres-make-base-backups\n",
		}
	} else  {
		file { '/etc/cron.d/puppet-postgres-make-base-backups':
			content  => "20 0 * * 6 debbackup chronic /usr/local/bin/postgres-make-base-backups\n",
		}
	}
}
