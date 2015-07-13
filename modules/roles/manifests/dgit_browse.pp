class roles::dgit_browse {
	#ssl::service { 'browse.dgit.debian.org':
	#	notify => Service['apache2'],
	#}

	package { 'cgit': ensure => installed, }

	file { '/etc/cgitrc':
		source => 'puppet:///modules/roles/dgit/cgitrc',
	}
	file { '/etc/apache2/conf-enabled/cgit.conf':
		ensure => absent,
		notify => Service['apache2'],
	}

	apache2::site { '010-browse.dgit.debian.org':
		site    => 'browse.dgit.debian.org',
		source => 'puppet:///modules/roles/dgit/browse.dgit.debian.org',
	}

}
