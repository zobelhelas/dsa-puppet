class roles::buildd_master {
	ssl::service { 'buildd.debian.org':
		notify => Service['apache2'],
	}

	file { '/etc/ssh/userkeys/wb-buildd.TEST':
		content => template('roles/buildd_master_wb-authorized_keys.erb'),
	}
}
