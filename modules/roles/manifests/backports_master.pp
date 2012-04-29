class roles::backports_master {

	include roles::backports_mirror

	vsftpd::site { 'backports':
		banner     => 'backports-master.debian.org FTP server',
		logfile    => '/var/log/ftp/vsftpd-backports-master.debian.org.log',
		writable   => true,
		chown_user => dak,
		root       => '/srv/backports-upload',
	}
}
