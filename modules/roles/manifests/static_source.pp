class roles::static_source {
	include roles::static_base
	file { '/etc/ssh/userkeys/staticsync':
		content => template('roles/static-mirroring/static-mirror-authorized_keys.erb'),
	}
	file { '/usr/local/bin/static-update-component':
		content => template('roles/static-mirroring/static-update-component.erb'),
		mode    => '0555',
	}
	file { '/usr/local/bin/static-mirror-ssh-wrap':
		source => 'puppet:///modules/roles/static-mirroring/static-mirror-ssh-wrap',
		mode   => '0555',
	}
}
