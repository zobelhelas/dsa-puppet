class hardware::raid::megactl {

	package { 'megactl':
		ensure => installed,
	}

	site::aptrepo { 'debian.restricted':
		url        => 'http://db.debian.org/debian-admin',
		suite      => 'lenny-restricted',
		components => 'non-free',
	}
}
