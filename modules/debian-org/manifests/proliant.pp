class debian-org::proliant {

	site::aptrepo { 'debian.restricted':
		template => 'debian-org/etc/apt/sources.list.d/debian.restricted.list.erb',
	}

	package { 'hpacucli':
		ensure  => installed,
		require => [
			File['/etc/apt/sources.list.d/debian.restricted.list'],
			Exec['apt-get update']
		]
	}
	package { 'hp-health':
		ensure => installed,
		require => [
			File['/etc/apt/sources.list.d/debian.restricted.list'],
			Exec['apt-get update']
		]
	}
	package { 'arrayprobe':
		ensure => installed,
	}

	if $::debarchitecture == 'amd64' {
		package { 'lib32gcc1':
			ensure => installed,
		}
	}
}
