class entropykey::local_consumer {

	package { 'ekeyd-egd-linux': ensure => installed }

	file { '/etc/default/ekeyd-egd-linux':
		source  => 'puppet:///modules/entropykey/ekeyd-egd-linux',
		notify  => Service['ekeyd-egd-linux'],
		require => Package['ekeyd-egd-linux'],
	}

	service { 'ekeyd-egd-linux':
		require => [
			File['/etc/default/ekeyd-egd-linux'],
			Package['ekeyd-egd-linux']
		]
	}
}
