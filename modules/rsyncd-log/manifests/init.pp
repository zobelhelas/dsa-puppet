class rsyncd-log {
	file { '/etc/logrotate.d/dsa-rsyncd':
		source  => 'puppet:///modules/rsyncd-log/logrotate.d-dsa-rsyncd',
		require => Package['debian.org'],
	}
	file { '/var/log/rsyncd':
		ensure  => directory,
		mode    => '0755',
	}
}
