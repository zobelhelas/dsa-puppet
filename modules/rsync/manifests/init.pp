class rsync {

	package { 'rsync':
		ensure => installed,
		noop   => true,
	}

	service { 'rsync':
		ensure  => stopped,
		noop    => true,
		require => Package['rsync'],
	}

	file { '/etc/logrotate.d/dsa-rsyncd':
		source  => 'puppet:///modules/rsyncd-log/logrotate.d-dsa-rsyncd',
		noop    => true,
		require => Package['debian.org'],
	}
	file { '/var/log/rsyncd':
		ensure => directory,
		noop   => true,
		mode   => '0755',
	}

	@ferm::rule { 'dsa-rsync':
		domain      => '(ip ip6)',
		description => 'Allow rsync access',
		rule        => '&SERVICE(tcp, 873)'
	}

}
