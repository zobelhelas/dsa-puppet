class puppetmaster {

	file { '/etc/puppet/hiera.yaml':
		source => 'puppet:///modules/puppetmaster/hiera.yaml'
	}

	@ferm::rule { 'dsa-puppet':
		description     => 'Allow puppet access',
		rule            => '&SERVICE_RANGE(tcp, 8140, $HOST_DEBIAN_V4)'
	}
	@ferm::rule { 'dsa-puppet-v6':
		domain          => 'ip6',
		description     => 'Allow puppet access',
		rule            => '&SERVICE_RANGE(tcp, 8140, $HOST_DEBIAN_V6)'
	}
}
