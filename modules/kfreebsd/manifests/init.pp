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
		notify  => Exec['update-rc.d procps defaults']
	}

	site::sysctl { 'maxfiles':
		key    => 'kern.maxfiles',
		value  => 65536,
		target => 'GNU/kFreeBSD',
	}
	site::sysctl { 'accept_ra':
		key    => 'net.inet6.ip6.accept_rtadv',
		value  => 0,
		target => 'GNU/kFreeBSD',
	}

	exec { 'update-rc.d procps defaults':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true,
	}
}
