class named::geodns inherits named {
	munin::check { 'bind_views':
		script => bind
	}

	site::aptrepo { 'geoip':
		template => 'debian-org/etc/apt/sources.list.d/geoip.list.erb',
	}

	file { '/etc/bind/':
		ensure  => directory,
		group  => bind,
		mode   => '2755',
		require => Package['bind9'],
		notify  => Service['bind9'],
	}
	file { '/etc/bind/geodns':
		ensure => directory,
		mode   => '0755',
	}
	file { '/etc/bind/named.conf.options':
		content => template('named/named.conf.options.erb'),
	}
	file { '/etc/bind/named.conf.local':
		source => 'puppet:///modules/named/common/named.conf.local',
	}
	file { '/etc/bind/named.conf.acl':
		source => 'puppet:///modules/named/common/named.conf.acl',
	}
	file { '/etc/bind/geodns/zonefiles':
		ensure => directory,
		owner  => geodnssync,
		group  => geodnssync,
		mode   => '2755',
	}
	file { '/etc/bind/geodns/named.conf.geo':
		source => 'puppet:///modules/named/common/named.conf.geo',
	}
	file { '/etc/bind/geodns/trigger':
		mode   => '0555',
		source => 'puppet:///modules/named/common/trigger',
	}
	file { '/etc/ssh/userkeys/geodnssync':
		source => 'puppet:///modules/named/common/authorized_keys',
		group  => geodnssync,
		mode   => '0440',
	}
	file { '/etc/cron.d/dsa-boot-geodnssync':
		source => 'puppet:///modules/named/common/cron-geo'
	}
}
