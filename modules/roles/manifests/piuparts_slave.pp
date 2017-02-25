class roles::piuparts_slave {
	package { 'debian.org-piuparts-slave.debian.org': ensure => installed, }

	file { [ '/srv/piuparts.debian.org', '/srv/piuparts.debian.org/home-slave']:
		ensure  => directory,
		mode    => '0755',
		owner   => 'piupartss',
		group   => 'piuparts',
	}
	file { '/home/piupartss':
		ensure => link,
		target => '/srv/piuparts.debian.org/home-slave',
	}

	file { '/etc/piuparts':
		ensure => link,
		target => '/srv/piuparts.debian.org/etc/piuparts',
	}
}
