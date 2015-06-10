class vsftpd {

	package { 'vsftpd':
		ensure => installed
	}
	package { 'logtail':
		ensure => installed
	}

	service { 'vsftpd':
		ensure  => stopped,
		require => Package['vsftpd']
	}

	file { '/etc/vsftpd.conf':
		content => "listen=NO\n",
		require => Package['vsftpd'],
		notify  => Service['vsftpd']
	}

	# Mask the vsftpd service as we are using xinetd
	file { '/etc/systemd/system/vsftpd.service':
		ensure => 'link',
		target => '/dev/null',
		notify => Exec['systemctl daemon-reload'],
	}


	munin::check { 'vsftpd':
		ensure => absent
	}
	munin::check { 'ps_vsftpd':
		script => 'ps_'
	}

	@ferm::rule { 'dsa-ftp':
		domain      => '(ip ip6)',
		description => 'Allow ftp access',
		rule        => '&SERVICE(tcp, 21)',
	}

	file { '/var/log/ftp':
		ensure => directory,
		mode   => '0755'
	}
	file { '/etc/logrotate.d/vsftpd':
		source  => 'puppet:///modules/vsftpd/logrotate.conf',
		require => [
			Package['vsftpd'],
			Package['debian.org']
		]
	}
}
