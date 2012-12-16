class roles::static_master {

	include roles::static_base

	file { '/etc/ssh/userkeys/staticsync':
		content => template('roles/static-mirroring/static-master-authorized_keys.erb'),
	}
	file { '/usr/local/bin/static-master-run':
		source => 'puppet:///modules/roles/static-mirroring/static-master-run',
		mode   => '0555',
	}
	file {'/usr/local/bin/static-master-ssh-wrap':
		source => 'puppet:///modules/roles/static-mirroring/static-master-ssh-wrap',
		mode   => '0555',
	}
	file { '/usr/local/bin/static-master-update-component':
		source => 'puppet:///modules/roles/static-mirroring/static-master-update-component',
		mode   => '0555',
	}
	file { '/etc/static-clients.conf':
		content => template('roles/static-mirroring/static-clients.conf.erb'),
	}
}
