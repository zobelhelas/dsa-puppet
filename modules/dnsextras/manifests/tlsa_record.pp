define dnsextras::tlsa_record (
	$zone,
	$certfile,
	$hostname,
	$port,
) {
	$snippet = gen_tlsa_entry($certfile, $hostname, $port)
	dnsextras::entry{ "$name":
		zone => "$zone",
		content => $snippet,
	}
}
