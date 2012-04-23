class debian-org::radvd {
	site::sysctl { 'dsa-accept-ra-default':
		key   => 'net.ipv6.conf.default.accept_ra',
		value => 0,
	}
	site::sysctl { 'dsa-accept-ra-all':
		key   => 'net.ipv6.conf.all.accept_ra',
		value => 0,
	}
}
