class ntp {

	package { 'ntp':
		ensure => installed
	}

	service { 'ntp':
		ensure  => running,
		require => Package['ntp']
	}

	@ferm::rule { 'dsa-ntp':
		domain      => '(ip ip6)',
		description => 'Allow ntp access',
		rule        => '&SERVICE(udp, 123)'
	}

	file { '/etc/init.d/ntp':
		source => 'puppet:///modules/ntp/ntp.init',
		mode   => '0555',
		notify => Exec['systemctl daemon-reload'],
	}
	file { '/var/lib/ntp':
		ensure  => directory,
		owner   => ntp,
		group   => ntp,
		mode    => '0755',
		require => Package['ntp']
	}
	file { '/etc/ntp.conf':
		content => template('ntp/ntp.conf'),
		notify  => Service['ntp'],
		require => Package['ntp'],
	}
	file { '/etc/ntp.keys.d':
		ensure  => directory,
		group   => 'ntp',
		mode    => '0750',
		notify  => Service['ntp'],
		require => Package['ntp'],
	}

	if getfromhash($site::nodeinfo, 'timeserver') {
		include ntp::timeserver
	} else {
		include ntp::client
	}
}
