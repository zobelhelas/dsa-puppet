class roles::syncproxy {
	rsync::site { 'syncproxy':
		source => 'puppet:///modules/roles/syncproxy/rsyncd.conf',
		bind   => $::hostname ? {
			'milanollo' => '5.153.231.9',
			'mirror-isc' => '149.20.20.21',
			default => ''
		},
		bind6   => $::hostname ? {
			'milanollo' => '2001:41c8:1000:21::21:9',
			'mirror-isc' => '2001:4f8:8:36::1deb:21',
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
