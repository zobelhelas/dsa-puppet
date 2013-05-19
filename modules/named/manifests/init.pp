class named {

	munin::check { 'bind': }

	site::aptrepo { 'bind-ratelimit':
		url        => 'http://db.debian.org/debian-admin',
		suite      => 'bind-ratelimit',
		components => 'main',
	}

	package { 'bind9':
		ensure => installed
	}

	service { 'bind9':
		ensure => running,
	}

	@ferm::rule { '00-dsa-bind-no-ddos-any':
		domain      => '(ip ip6)',
		description => 'Allow nameserver access',
		rule        => 'proto udp dport 53 mod string from 32 to 64 algo bm hex-string \'|0000ff0001|\' jump DROP'
	}

	@ferm::rule { '01-dsa-bind':
		domain      => '(ip ip6)',
		description => 'Allow nameserver access',
		rule        => '&TCP_UDP_SERVICE(53)'
	}

	@ferm::rule { 'dsa-bind-notrack':
		domain      => '(ip ip6)',
		description => 'NOTRACK for nameserver traffic',
		table       => 'raw',
		chain       => 'PREROUTING',
		rule        => 'proto (tcp udp) dport 53 jump NOTRACK'
	}

	@ferm::rule { 'dsa-bind-notrack-out':
		domain      => '(ip ip6)',
		description => 'NOTRACK for nameserver traffic',
		table       => 'raw',
		chain       => 'OUTPUT',
		rule        => 'proto (tcp udp) sport 53 jump NOTRACK'
	}

	file { '/var/log/bind9':
		ensure => directory,
		owner  => bind,
		group  => bind,
		mode   => '0775',
	}
}
