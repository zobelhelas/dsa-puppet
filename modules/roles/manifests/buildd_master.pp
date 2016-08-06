class roles::buildd_master {
	ssl::service { 'buildd.debian.org':
		notify  => Exec['service apache2 reload'],
	}

	file { '/etc/ssh/userkeys/wb-buildd.more':
		content => template('roles/buildd_master_wb-authorized_keys.erb'),
	}
}
