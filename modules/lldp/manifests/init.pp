class lldp {
	package { 'lldpd':
		ensure => installed
	}

	service { 'lldpd':
		ensure    => running,
		hasstatus => false,
		pattern   => '/usr/sbin/lldpd',
		require   => Package['lldpd']
	}
}
