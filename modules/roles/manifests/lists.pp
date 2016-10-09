class roles::lists {
	ssl::service { 'lists.debian.org':
		notify  => Exec['service apache2 reload'],
		tlsaport => 0,
	}

	dnsextras::tlsa_record{ 'tlsa-mailport':
		zone     => 'debian.org',
		certfile => "/etc/puppet/modules/exim/files/certs/${::fqdn}.crt",
		port     => 25,
		hostname => $::fqdn,
	}
}
