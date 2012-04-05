class samhain {

	package { 'samhain':
		ensure => installed,
		noop   => true,
	}

	service { 'samhain':
		ensure => running,
		hasstatus => false,
		pattern   => 'samhain',
	}

	file { '/etc/samhain/samhainrc':
		content => template('samhain/samhainrc.erb'),
		require => Package['samhain'],
		notify  => Service['samhain']
	}
}
