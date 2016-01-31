class roles::syncproxy {
	$bind = $::hostname ? {
		'milanollo' => '5.153.231.9',
		'mirror-anu' => '150.203.164.60',
		'mirror-isc' => '149.20.20.21',
		'mirror-umn' => '128.101.240.216',
		'klecker' => '130.89.148.10',
		default => ''
	}
	$bind6 = $::hostname ? {
		'milanollo' => '2001:41c8:1000:21::21:9',
		'mirror-anu' => '2001:388:1034:2900::3c',
		'mirror-isc' => '2001:4f8:8:36::1deb:21',
		'mirror-umn' => '2607:ea00:101:3c0b::1deb:216',
		'klecker' => '2001:610:1908:b000::148:10',
		default => ''
	}
	$syncproxy_name = $::hostname ? {
		'milanollo' => 'syncproxy3.eu.debian.org',
		'mirror-anu' => 'syncproxy.au.debian.org',
		'mirror-isc' => 'syncproxy2.wna.debian.org',
		'mirror-umn' => 'syncproxy.cna.debian.org',
		'klecker' => 'syncproxy2.eu.debian.org',
		default => 'unknown'
	}

	rsync::site { 'syncproxy':
		content => template('roles/syncproxy/rsyncd.conf.erb'),
		bind    => $bind,
		bind6   => $bind6,
	}

	file { '/etc/rsyncd':
		ensure => 'directory'
	}

	file { '/etc/rsyncd/debian.secrets':
		owner => 'root',
		group => 'mirroradm',
		mode => 0660,
	}

	if $::apache2 and $syncproxy_name != 'unknown' {
		include apache2::ssl
		ssl::service { "$syncproxy_name": notify => Service['apache2'], key => true, }
		apache2::site { '010-syncproxy.debian.org':
			site   => 'syncproxy.debian.org',
			content => template('roles/syncproxy/syncproxy.debian.org-apache.erb')
		}

		file { [ '/srv/www/syncproxy.debian.org', '/srv/www/syncproxy.debian.org/htdocs' ]:
			ensure  => directory,
			mode    => '0755',
		}
		file { '/srv/www/syncproxy.debian.org/htdocs/index.html':
			content => template('roles/syncproxy/syncproxy.debian.org-index.html.erb')
		}
	}
}
