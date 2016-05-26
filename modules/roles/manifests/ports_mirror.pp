class roles::ports_mirror {
	$vhost_listen = $::hostname ? {
		klecker    => '130.89.148.14:80 [2001:610:1908:b000::148:14]:80',
		mirror-isc => '149.20.20.22:80 [2001:4f8:8:36::1deb:22]:80',
		default => '*:80',
	}

	apache2::site { '010-ports.mirrors.debian.org':
		site   => 'ports.mirrors.debian.org',
		content => template('roles/apache-ftp.ports.debian.org.erb'),
	}
}
