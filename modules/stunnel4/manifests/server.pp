define stunnel4::server($accept, $connect, $local = '127.0.0.1') {
# define an stunnel listener, listening for SSL connections on $accept,
# connecting to plaintext service $connect using local source address $local
#
# unfortunately stunnel is really bad about verifying its peer,
# all we can be certain of is that they are signed by our CA,
# not who they are.  So do not use in places where the identity of
# the caller is important.  Use dsa-portforwarder for that.

	include stunnel4

	stunnel_generic { $name:
		client  => false,
		verify  => 2,
		cafile  => '/etc/exim4/ssl/ca.crt',
		crlfile => '/etc/exim4/ssl/crl.crt',
		accept  => $accept,
		connect => $connect
	}

	@ferm::rule {
		"stunnel-${name}":
			description => "stunnel ${name}",
			rule        => "&SERVICE_RANGE(tcp, ${accept}, \$HOST_DEBIAN_V4)"
	}
	@ferm::rule { "stunnel-${name}-v6":
			domain      => 'ip6',
			description => "stunnel ${name}",
			rule        => "&SERVICE_RANGE(tcp, ${accept}, \$HOST_DEBIAN_V6)"
	}

}
