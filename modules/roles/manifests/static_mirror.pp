class roles::static_mirror {

	include roles::static_source

	package { 'libapache2-mod-macro':
		ensure => installed,
	}

	apache2::module { 'macro': require => Package['libapache2-mod-macro']; }
	apache2::module { 'rewrite': }
	apache2::module { 'expires': }

	apache2::config { "local-static-vhost.conf":
		source  => "puppet:///modules/roles/static-mirroring/static-vhost.conf",
	}

	file { '/usr/local/bin/static-mirror-run':
		source => 'puppet:///modules/roles/static-mirroring/static-mirror-run',
		mode   => '0555',
	}

	file { '/srv/static.debian.org':
		ensure => directory,
		owner  => staticsync,
		group  => staticsync,
		mode   => '02755'
	}

	file { '/etc/cron.d/puppet-static-mirror':
			content => "PATH=/usr/local/bin:/usr/bin:/bin\n@reboot staticsync sleep 60; static-mirror-run --one-stage /srv/static.debian.org bizet.debian.org:-live- > /dev/null\n",
	}

	$vhost_listen = $::hostname ? {
		klecker => '130.89.148.14:80 [2001:610:1908:b000::148:14]:80',
		default => '*:80',
	}

	apache2::site { '010-planet.debian.org':
		site    => 'planet.debian.org',
		content => template('roles/static-mirroring/vhost/planet.debian.org.erb'),
	}

	apache2::site { '10-static-vhosts-simple':
		site => "static-vhosts-simple",
		content => template('roles/static-mirroring/vhost/static-vhosts-simple.erb'),
	}
}
