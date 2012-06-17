class hardware::raid::megactl {

	package { 'megactl':
		ensure => installed,
		require => [
			File['/etc/apt/sources.list.d/debian.restricted.list'],
			Exec['apt-get update']
		]
	}

	site::aptrepo { 'debian.restricted':
		url        => 'http://db.debian.org/debian-admin',
		suite      => 'lenny-restricted',
		components => 'non-free',
	}
}
