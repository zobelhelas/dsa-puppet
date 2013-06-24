class roles::syncproxy {
	rsync::site { 'syncproxy':
		source => 'puppet:///modules/roles/syncproxy/rsyncd.conf',
		bind   => $::hostname ? {
			'milanollo' => '5.153.231.9',
			default => ''
		}
	}

	file { '/etc/rsyncd':
		ensure => 'directory'
	}

	file { '/etc/rsyncd/debian.secrets':
		owner => 'root',
		group => 'mirroradm',
		mode => 0664,
	}
}
