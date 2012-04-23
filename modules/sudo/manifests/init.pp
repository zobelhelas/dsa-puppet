class sudo {

	package { 'sudo':
		ensure => installed
	}

	file { '/etc/pam.d/sudo':
		source  => 'puppet:///modules/sudo/pam',
		require => Package['sudo'],
	}

	file { '/etc/sudoers':
		mode    => '0440',
		source  => [ "puppet:///modules/sudo/sudoers.${::lsbdistcodename}",
			'puppet:///modules/sudo/sudoers' ],
		require => Package['sudo'],
	}
}
