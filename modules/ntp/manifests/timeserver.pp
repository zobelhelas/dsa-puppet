class ntp::timeserver {
	if ($::lsbmajdistrelease >= 8) {
		file { '/var/lib/ntp/leap-seconds.list':
			ensure => absent,
		}
	} else {
		file { '/var/lib/ntp/leap-seconds.list':
			source  => 'puppet:///modules/ntp/leap-seconds.list',
			require => Package['ntp'],
			notify  => Service['ntp'],
		}
	}
}
