class postgrey {

	package { 'postgrey':
		ensure => installed
	}

	service { 'postgrey':
		ensure  => running,
		require => Package['postgrey']
	}

	file { '/etc/default/postgrey':
		source  => 'puppet:///modules/postgrey/default',
		require => Package['postgrey'],
		notify  => Service['postgrey']
	}
}
