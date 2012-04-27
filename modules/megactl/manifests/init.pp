class megactl {
	package { 'megactl':
		ensure => installed,
		require => [
			File['/etc/apt/sources.list.d/debian.restricted.list'],
			Exec['apt-get update']
		]
	}

	site::aptrepo { 'debian.restricted':
		template => 'debian-org/etc/apt/sources.list.d/debian.restricted.list.erb',
	}
}
