class stunnel4 {

	package { 'stunnel4':
		ensure => installed
	}

	file { '/etc/stunnel':
		ensure  => directory,
		mode    => '0755',
	}
	file { '/etc/init.d/stunnel4':
		source => 'puppet:///modules/stunnel4/etc-init.d-stunnel4',
		mode   => '0555',
		notify => Exec['systemctl daemon-reload'],
	}
	file { '/etc/stunnel/stunnel.conf':
		ensure  => absent,
		require => Package['stunnel4'],
	}

	exec { 'enable_stunnel4':
		command => 'sed -i -e \'s/^ENABLED=/#&/; $a ENABLED=1 # added by puppet\' /etc/default/stunnel4',
		unless  => 'grep -q \'^ENABLED=1\' /etc/default/stunnel4',
		require => Package['stunnel4'],
	}
	exec { 'kill_file_override':
		command => 'sed -i -e \'s/^FILES=/#&/\' /etc/default/stunnel4',
		onlyif  => 'grep -q \'^FILES=\' /etc/default/stunnel4',
		require => Package['stunnel4'],
	}
}
