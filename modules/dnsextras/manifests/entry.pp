define dnsextras::entry (
	$zone,
	$content,
) {
	@@concat::fragment { "dns-extra-${zone}-${::fqdn}-${name}":
		target  => "/srv/dns.debian.org/puppet-extra/include-${zone}",
		content => "; ${::fqdn} ${name}\n${content}\n",
		tag => 'dnsextra',
	}
}
