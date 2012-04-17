class megactl {
	package { 'megactl':
		ensure => installed
	}

	site::aptrepo { 'debian.restricted':
		template => 'debian-org/etc/apt/sources.list.d/debian.restricted.list.erb',
	}
}
