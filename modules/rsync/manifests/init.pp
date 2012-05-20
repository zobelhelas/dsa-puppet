class rsync {

	package { 'rsync':
		ensure => installed,
	}

	service { 'rsync':
		ensure  => stopped,
		require => Package['rsync'],
	}

	file { '/etc/logrotate.d/dsa-rsyncd':
		source  => 'puppet:///modules/rsync/logrotate.d-dsa-rsyncd',
		require => Package['debian.org'],
	}
	file { '/var/log/rsyncd':
		ensure => directory,
		mode   => '0755',
	}

	@ferm::rule { 'dsa-rsync':
		domain      => '(ip ip6)',
		description => 'Allow rsync access',
		rule        => '&SERVICE(tcp, 873)'
	}

}
