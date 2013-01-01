class hardware::raid::proliant {

	site::aptrepo { 'debian.restricted':
		url        => 'http://db.debian.org/debian-admin',
		suite      => 'lenny-restricted',
		components => 'non-free',
	}

	package { 'hpacucli':
		ensure  => installed,
	}
	package { 'hp-health':
		ensure => installed,
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
