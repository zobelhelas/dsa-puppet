class onion::balance {
	include onion

	package { 'onionbalance':
		ensure => installed,
	}
	service { 'onionbalance':
		ensure => running,
		require => Package['onionbalance'],
	}

	file { '/usr/local/bin/tor-onion-name':
		mode    => '0555',
		source  => 'puppet:///modules/onion/tor-onion-name',
	}

	concat::fragment { 'onion::torrc_control_header':
		target  => "/etc/tor/torrc",
		order   => 10,
		content => "ControlPort 9051\n\n",
	}

	concat { '/etc/onionbalance/config.yaml':
		notify  => Service['onionbalance'],
		require => Package['onionbalance'],
	}
	concat::fragment { 'onion::balance::config_header':
		target  => "/etc/onionbalance/config.yaml",
		order   => 05,
		content => "service:\n",
	}
}
