class roles::bgp {
	$bgp_peers = $::hostname ? {
		bilbao        => '2001:41c9:2:13c::2/128 89.16.162.2/32',
		mirror-conova => '2a02:16a8:5404:199::25/128 217.196.157.53/32',
		default       => undef,
	}

	if ! $bgp_peers {
		fail("Do not have bgp_peers set for $::hostname.")
	}

	@ferm::rule { 'dsa-bgp':
		description => 'Allow BGP from peers',
		domain      => '(ip ip6)',
		rule        => "&SERVICE_RANGE(tcp, bgp, ($bgp_peers))"
	}

	file { '/etc/network/interfaces.d/anycasted':
		content => template('roles/anycast/interfaces.erb')
	}

}
