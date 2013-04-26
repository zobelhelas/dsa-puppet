class roles::static_source {

	include roles::static_base

	file { '/usr/local/bin/static-update-component':
		source => 'puppet:///modules/roles/static-mirroring/static-update-component',
		mode    => '0555',
	}
}
