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
	file { '/usr/local/bin/create-onionbalance-config':
		mode    => '0555',
		source  => 'puppet:///modules/onion/create-onionbalance-config',
		notify  => Exec['create-onionbalance-config'],
	}

	concat::fragment { 'onion::torrc_control_header':
		target  => "/etc/tor/torrc",
		order   => '10',
		content => "ControlPort 9051\n\n",
	}

	@@concat::fragment { "onion::balance::onionbalance-services.yaml":
		target  => "/srv/puppet.debian.org/puppet-facts/onionbalance-services.yaml",
		content => "${onion_balance_service_hostname}\n",
		tag     => "onionbalance-services.yaml",
	}

	concat { '/etc/onionbalance/config-dsa-snippet.yaml':
		notify  => Exec['create-onionbalance-config'],
		require => File['/usr/local/bin/create-onionbalance-config']
	}
	Concat::Fragment <<| tag == "onion::balance::dsa-snippet" |>>

	exec { "create-onionbalance-config":
		command => "/usr/local/bin/create-onionbalance-config",
		refreshonly => true,
		require => [ File['/usr/local/bin/create-onionbalance-config'], Package['onionbalance'] ],
		notify  => Service['onionbalance'],
	}
}
