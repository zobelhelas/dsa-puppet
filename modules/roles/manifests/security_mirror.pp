class roles::security_mirror {

	apache2::site { '010-security.debian.org':
		site   => 'security.debian.org',
		config => 'puppet:///modules/roles/security_mirror/security.debian.org'
	}

	vsftpd::site { 'security':
		banner       => 'security.debian.org FTP server (vsftpd)',
		logfile      => '/var/log/ftp/vsftpd-security.debian.org.log',
		max_clients  => 200,
		root         => '/srv/ftp.root/',
	}
}
