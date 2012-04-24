class xinetd {
	package { 'xinetd':
		ensure => installed,
		noop   => true,
	}

	service { 'xinetd':
		ensure => running,
		noop   => true,
	}
}
