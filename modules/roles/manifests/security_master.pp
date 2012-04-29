class roles::security_master {

	vsftpd::site { 'security':
		banner     => 'security-master.debian.org FTP server (vsftpd)',
		logfile    => '/var/log/ftp/vsftpd-security-master.debian.org.log',
		writable   => true,
		chown_user => dak,
		root       => '/srv/ftp.root/',
	}
}
