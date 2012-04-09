class ganeti2 {

	package { 'ganeti2':
		ensure => installed
	}

	package { 'drbd8-utils':
		ensure => installed
	}

}
