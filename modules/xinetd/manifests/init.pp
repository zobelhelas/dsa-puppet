class xinetd {
	package { 'xinetd':
		ensure => installed,
	}

	service { 'xinetd':
		ensure    => running,
		hasstatus => false,
		pattern   => '/usr/sbin/xinetd',
		require   => Package['xinetd']
	}
}
