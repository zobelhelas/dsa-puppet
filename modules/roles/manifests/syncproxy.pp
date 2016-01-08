class roles::syncproxy {
	rsync::site { 'syncproxy':
		content => template('roles/syncproxy/rsyncd.conf.erb'),
		bind   => $::hostname ? {
			'milanollo' => '5.153.231.9',
			'mirror-isc' => '149.20.20.21',
			'mirror-umn' => '128.101.240.216',
			'klecker' => '130.89.148.10',
			default => ''
		},
		bind6   => $::hostname ? {
			'milanollo' => '2001:41c8:1000:21::21:9',
			'mirror-isc' => '2001:4f8:8:36::1deb:21',
			'mirror-umn' => '2607:ea00:101:3c0b::1deb:216',
			'klecker' => '2001:610:1908:b000::148:10',
			default => ''
		},
	}

	file { '/etc/rsyncd':
		ensure => 'directory'
	}

	file { '/etc/rsyncd/debian.secrets':
		owner => 'root',
		group => 'mirroradm',
		mode => 0660,
	}
}
