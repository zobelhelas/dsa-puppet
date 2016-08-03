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
		content => "services:\n",
	}

	@@concat::fragment { "onion::balance::onionbalance-services.yaml":
		target  => "/srv/puppet.debian.org/puppet-facts/onionbalance-services.yaml",
		content => "${onion_balance_service_hostname}\n",
		tag     => "onionbalance-services.yaml",
	}


	concat { '/etc/onionbalance/config-dsa-snippet.yaml':
		# notify  => Service['onionbalance'],
		# require => Package['onionbalance'],
	}
	Concat::Fragment <<| tag == "onion::balance::dsa-snippet" |>>
}
