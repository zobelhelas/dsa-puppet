class kfreebsd {
	file { '/etc/cron.d/dsa-killruby':
		source => 'puppet:///modules/kfreebsd/dsa-killruby',
	}

	site::sysctl { 'maxfiles':
		key    => 'kern.maxfiles',
		value  => 65536,
		target => 'GNU/kFreeBSD',
	}
}
