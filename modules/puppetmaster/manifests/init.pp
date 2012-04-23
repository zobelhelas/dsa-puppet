class puppetmaster {
	file { '/etc/puppet/hiera.yaml':
		source => 'puppet:///modules/puppetmaster/hiera.yaml'
	}
}
