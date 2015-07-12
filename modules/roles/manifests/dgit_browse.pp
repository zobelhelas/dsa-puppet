class roles::dgit_browse {
	#ssl::service { 'wiki.debian.org':
	#	notify => Service['apache2'],
	#}
	#rsync::site { 'wiki':
	#	source => 'puppet:///modules/roles/wiki/rsyncd.conf',
	#}

	package { 'cgi': ensure => installed, }

	file { '/etc/cgitrc':
		source => 'puppet:///modules/roles/dgit/cgitrc',
	}

	apache2::site { '010-browse.dgit.debian.org':
		site    => 'browse.dgit.debian.org',
		source => 'puppet:///modules/roles/dgit/browse.dgit.debian.org',
	}

}
