define dnsextras::entry (
	$zone,
	$label,
	$rrtype,
	$rrdata,
) {
	@@concat::fragment { "dns-extra-${zone}-${::fqdn}-${name}":
		target  => "/srv/dns.debian.org/puppet-extra/include-${zone}",
		content => "; ${::fqdn} ${name}\n${label}. IN ${rrtype} ${rrdata}\n",
		tag => 'dnsextra',
	}
}
