class ntp::timeserver {
	file { '/var/lib/ntp/leap-seconds.list':
		source  => 'puppet:///modules/ntp/leap-seconds.list',
		require => Package['ntp'],
		notify  => Service['ntp'],
	}
}
