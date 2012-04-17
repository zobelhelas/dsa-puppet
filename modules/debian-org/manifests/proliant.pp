class debian-org::proliant {

	site::aptrepo { 'debian.restricted':
		template => 'debian-org/etc/apt/sources.list.d/debian.restricted.list.erb',
	}

	package { 'hpacucli':
		ensure => installed,
	}
	package { 'hp-health':
		ensure => installed,
	}
	package { 'arrayprobe':
		ensure => installed,
	}

	if $::lsbdistcodename == 'lenny' {
		package { 'cpqarrayd':
			ensure => installed,
		}
	}

	if $::debarchitecture == 'amd64' {
		package { 'lib32gcc1':
			ensure => installed,
		}
	}
}


