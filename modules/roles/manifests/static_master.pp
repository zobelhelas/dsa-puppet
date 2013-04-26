class roles::static_master {

	include roles::static_base

	file { '/usr/local/bin/static-master-run':
		source => 'puppet:///modules/roles/static-mirroring/static-master-run',
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
