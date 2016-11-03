class ntp::timeserver {
	file { '/var/lib/ntp/leap-seconds.list':
		ensure => absent,
	}
}
