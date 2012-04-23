class kfreebsd {

	file { '/etc/cron.d/dsa-killruby':
		source => 'puppet:///modules/kfreebsd/dsa-killruby',
	}

	file { '/etc/sysctl.d/':
		ensure => directory,
		mode   => '0755'
	}

	file { '/etc/init.d/procps':
		source => 'puppet:///modules/kfreebsd/procps.init',
		mode   => '0555',
		before => Service['procps'],
	}

	site::sysctl { 'maxfiles':
		key    => 'kern.maxfiles',
		value  => 65536,
		target => 'GNU/kFreeBSD',
	}
}
