class roles::backports_master {

	include roles::backports_mirror

	vsftpd::site { 'backports':
		banner     => 'backports-master.debian.org FTP server',
		logfile    => '/var/log/ftp/vsftpd-backports-master.debian.org.log',
		writable   => true,
		chown_user => dak-unpriv,
		root       => '/srv/backports-upload',
	}

	rsync::site { 'backports_master':
		source        => 'puppet:///modules/roles/backports_master/rsyncd.conf',
		max_clients => 100,
	}
}
