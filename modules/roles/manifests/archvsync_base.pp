class roles::archvsync_base {
	file { '/srv/mirrors':
		ensure => directory,
		owner  => root,
		group  => 1176, # archvsync
		mode   => '0775',
		# links  => follow,
	}

	file { '/srv/mirrors/.nobackup':
		ensure  => present,
		content => '',
	}
}
