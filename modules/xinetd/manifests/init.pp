class xinetd {
	package { 'xinetd':
		ensure => installed,
		noop   => true,
	}

	service { 'xinetd':
		ensure    => running,
		hasstatus => false,
		pattern   => '/usr/sbin/xinetd',
		noop      => true,
		require   => Package['xinetd']
	}
}
