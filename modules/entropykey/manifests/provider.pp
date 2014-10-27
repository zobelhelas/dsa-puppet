class entropykey::provider {

	package { 'ekeyd': ensure => installed }

	file { '/etc/entropykey/ekeyd.conf':
		source  => 'puppet:///modules/entropykey/ekeyd.conf',
		notify  => Service['ekeyd'],
		require => Package['ekeyd'],
	}

	# our CRL expires after a while (2 or 4 weeks?), so we have
	# to restart stunnel so it loads the new CRL.
	file { '/etc/cron.weekly/stunnel-ekey-restart':
		content => "#!/bin/sh\n# This file is under puppet control\n# weekly restart of stunnel on ${::hostname}\nenv -i /etc/init.d/stunnel4 restart puppet-ekeyd | grep -vF 'Restarting SSL tunnels: [stopped: /etc/stunnel/puppet-ekeyd.conf] [Started: /etc/stunnel/puppet-ekeyd.conf] stunnel.'\n",
		mode    => '0555',
	}

	service { 'ekeyd':
		ensure  => running,
		require => [
			File['/etc/entropykey/ekeyd.conf'],
			Package['ekeyd']
		]
	}

	stunnel4::server { 'ekeyd':
		accept  => 18888,
		connect => '127.0.0.1:8888',
	}
}
