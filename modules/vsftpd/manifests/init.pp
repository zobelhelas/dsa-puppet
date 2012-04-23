class vsftpd {

	package { 'vsftpd':
		ensure => installed
	}
	package { 'logtail':
		ensure => installed
	}

	service { 'vsftpd':
		ensure => running
	}

	munin::check { 'vsftpd': }
	munin::check { 'ps_vsftpd':
		script => 'ps_'
	}

	@ferm::rule { 'dsa-ftp':
		domain      => '(ip ip6)',
		description => 'Allow ftp access',
		rule        => '&SERVICE(tcp, 21)',
	}
}
