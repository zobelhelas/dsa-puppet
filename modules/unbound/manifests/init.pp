# = Class: unbound
#
# This class installs and configures unbound
#
# == Sample Usage:
#
#   include unbound
#
class unbound {

	$is_recursor   = getfromhash($site::nodeinfo, 'misc', 'resolver-recursive')
	$client_ranges = getfromhash($site::nodeinfo, 'hoster', 'allow_dns_query')
	$ns            = hiera('nameservers')

	package { 'unbound':
		ensure => installed
	}

	service { 'unbound':
		ensure => running,
		hasstatus => false,
		pattern   => 'unbound',
	}

	file { '/var/lib/unbound':
		ensure  => directory,
		owner   => unbound,
		group   => unbound,
		require => Package['unbound'],
		mode    => '0775',
	}
	file { '/var/lib/unbound/root.key':
		ensure  => present,
		replace => false,
		owner   => unbound,
		group   => unbound,
		mode    => '0644',
		source  => 'puppet:///modules/unbound/root.key'
	}
	file { '/var/lib/unbound/debian.org.key':
		ensure  => present,
		replace => false,
		owner   => unbound,
		group   => unbound,
		mode    => '0644',
		source  => 'puppet:///modules/unbound/debian.org.key'
	}
	file { '/etc/unbound/unbound.conf':
		content => template('unbound/unbound.conf.erb'),
		require => [
			Package['unbound'],
			File['/var/lib/unbound/root.key'],
			File['/var/lib/unbound/debian.org.key']
		],
		notify  => Service['unbound']
	}

	if ($is_recursor and $client_ranges) {
		@ferm::rule { 'dsa-dns':
			domain      => 'ip',
			description => 'Allow nameserver access',
			rule        => sprintf('&TCP_UDP_SERVICE_RANGE(53, (%s))', join_spc(filter_ipv4(getfromhash($site::nodeinfo, 'hoster', 'allow_dns_query')))),
		}
		@ferm::rule { 'dsa-dns6':
			domain      => 'ip6',
			description => 'Allow nameserver access',
			rule        => sprintf('&TCP_UDP_SERVICE_RANGE(53, (%s))', join_spc(filter_ipv6(getfromhash($site::nodeinfo, 'hoster', 'allow_dns_query')))),
		}
	}
}
