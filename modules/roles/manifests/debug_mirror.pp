class roles::debug_mirror {
	$vhost_listen = $::hostname ? {
		klecker => '130.89.148.14:80 [2001:610:1908:b000::148:14]:80',
		default => '*:80',
	}

	apache2::site { '010-debug.mirrors.debian.org':
		site   => 'debug.mirrors.debian.org',
		content => template('roles/apache-debug.mirrors.debian.org.erb'),
	}
}
