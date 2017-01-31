class roles::bgp {
	$bgp_peers = $::hostname ? {
		bilbao    => '2001:41c9:2:13c::/128 89.16.162.0/32',
		boman     => '',
		default    => undef,
	}

	if ! $bgp_peers {
		fail("Do not have bgp_peers set for $::hostname.")
	}

	@ferm::rule { 'dsa-bgp':
		description => 'Allow BGP from peers',
		domain      => '(ip ip6)',
		rule        => "&SERVICE_RANGE(tcp, bgp, ($bgp_peers))"
	}
}
