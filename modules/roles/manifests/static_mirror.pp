class roles::static_mirror {

	include roles::static_source
	include apache2::cache

	package { 'libapache2-mod-geoip': ensure => installed, }
	package { 'geoip-database': ensure => installed, }

	apache2::module { 'include': }
	apache2::module { 'ssl': }
	apache2::module { 'geoip': require => [Package['libapache2-mod-geoip'], Package['geoip-database']]; }

	file { '/usr/local/bin/static-mirror-run':
		source => 'puppet:///modules/roles/static-mirroring/static-mirror-run',
		mode   => '0555',
	}

	file { '/usr/local/bin/static-mirror-run-all':
		source => 'puppet:///modules/roles/static-mirroring/static-mirror-run-all',
		mode   => '0555',
	}

	file { '/srv/static.debian.org':
		ensure => directory,
		owner  => staticsync,
		group  => staticsync,
		mode   => '02755'
	}

	file { '/etc/cron.d/puppet-static-mirror':
			content => "MAILTO=root\nPATH=/usr/local/bin:/usr/bin:/bin\n@reboot staticsync sleep 60; chronic static-mirror-run-all\n",
	}

	$vhost_listen = $::hostname ? {
		klecker => '130.89.148.14:80 [2001:610:1908:b000::148:14]:80',
		default => '*:80',
	}
	$vhost_listen_443 = $::hostname ? {
		klecker => '130.89.148.14:443 [2001:610:1908:b000::148:14]:443',
		default => '*:443',
	}

	apache2::config { 'local-static-vhost.conf':
		content => template('roles/static-mirroring/static-vhost.conf.erb'),
	}

	apache2::site { '010-planet.debian.org':
		site    => 'planet.debian.org',
		content => template('roles/static-mirroring/vhost/planet.debian.org.erb'),
	}

	apache2::site { '010-lintian.debian.org':
		site    => 'lintian.debian.org',
		content => template('roles/static-mirroring/vhost/lintian.debian.org.erb'),
	}

	apache2::site { '010-static-vhosts-simple':
		site => 'static-vhosts-simple',
		content => template('roles/static-mirroring/vhost/static-vhosts-simple.erb'),
	}

	$wwwdo_document_root = '/srv/static.debian.org/mirrors/www.debian.org/cur'
	apache2::site { '005-www.debian.org':
		site   => 'www.debian.org',
		content => template('roles/apache-www.debian.org.erb'),
	}

	ssl::service { 'dsa.debian.org':
		notify => Service['apache2'],
	}
	ssl::service { 'www.debian.org':
		notify => Service['apache2'],
	}
	ssl::service { 'bits.debian.org':
		notify => Service['apache2'],
	}
	ssl::service { 'lintian.debian.org':
		notify => Service['apache2'],
	}
	ssl::service { 'rtc.debian.org':
		notify => Service['apache2'],
	}
}
