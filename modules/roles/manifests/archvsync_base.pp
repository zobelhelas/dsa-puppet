class roles::archvsync_base {
	file { '/srv/mirrors':
		ensure => directory,
		owner  => 1176,
		group  => 1176,
		mode   => '0755',
		links  => follow,
	}

	file { '/srv/mirrors/.nobackup':
		ensure  => present,
		content => '',
		mode    => '0444',
	}
}
