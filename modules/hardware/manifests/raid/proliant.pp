class hardware::raid::proliant {

	site::aptrepo { 'debian.restricted':
		url        => 'http://db.debian.org/debian-admin',
		suite      => "${::lsbdistcodename}-restricted",
		components => 'non-free',
	}

	package { 'hpacucli':
		ensure  => installed,
		tag    => extra_repo,
	}
	if ! "$::systemproductname" in ["ProLiant DL180 G5", "ProLiant DL120 G5"] {
		package { 'hp-health':
			ensure => installed,
			tag    => extra_repo,
		}
	}

	if $::debarchitecture == 'amd64' {
		package { 'lib32gcc1':
			ensure => installed,
		}
	}
}
