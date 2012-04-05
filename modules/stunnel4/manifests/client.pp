define stunnel4::client($accept, $connecthost, $connectport) {

	include stunnel4

	file { "/etc/stunnel/puppet-${name}-peer.pem":
		content => generate('/bin/cat', "/etc/puppet/modules/exim/files/certs/${connecthost}.crt",
			'/etc/puppet/modules/exim/files/certs/ca.crt'),
		notify  => Exec["restart_stunnel_${name}"],
	}

	stunnel4::generic { $name:
		client  => true,
		verify  => 3,
		cafile  => "/etc/stunnel/puppet-${name}-peer.pem",
		accept  => $accept,
		connect => "${connecthost}:${connectport}",
	}
}

