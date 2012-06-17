class roles::security_master {

	vsftpd::site { 'security':
		banner     => 'security-master.debian.org FTP server (vsftpd)',
		logfile    => '/var/log/ftp/vsftpd-security-master.debian.org.log',
		writable   => true,
		chown_user => dak,
		root       => '/srv/ftp.root/',
	}

	rsync::site { 'security_master':
		source        => 'puppet:///modules/roles/security_master/rsyncd.conf',
		max_clients => 100,
	}
}
