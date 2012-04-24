class xinetd {
	package { 'xinetd':
		ensure => installed
	}

	service { 'xinetd':
		ensure => running
	}
}
