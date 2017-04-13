class roles::bgp {
	$bgp_peers = $::hostname ? {
		mirror-bytemark => '2001:41c9:2:13c::2/128 89.16.162.2/32',
		mirror-conova => '2a02:16a8:5404:199::25/128 217.196.157.53/32',
		mirror-accumu => '2001:6b0:1e:2::1c6/128 130.242.6.198/32',
		mirror-skroutz => '2a03:e40:42:200::151:1/128 2a03:e40:42:200::151:2/128 154.57.0.249/32 154.57.0.250',
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
