class roles::ports-master {
	rsync::site { 'ports-master':
		source        => 'puppet:///modules/roles/ports-master/rsyncd.conf',
		max_clients   => 100,
		sslname       => 'ports-master.debian.org',
	}

	ssl::service { 'ports-master.debian.org':
		key => true,
	}

	file { '/etc/rsyncd':
		ensure => 'directory'
	}

	file { '/etc/rsyncd/debian.secrets':
		owner => 'root',
		group => 'mirroradm',
		mode => 0660,
	}
}
