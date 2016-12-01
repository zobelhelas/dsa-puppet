class popcon {
	$popcon_host_id = hkdf('/etc/puppet/secret', "popcon_host_id-${::fqdn}")

	package { 'popularity-contest':
		ensure => installed,
	}

	file { '/etc/popularity-contest.conf':
		content => template('popcon/popularity-contest.conf.erb')
	}
}
