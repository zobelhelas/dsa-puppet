class roles::ports_master {
	rsync::site { 'ports-master':
		source      => 'puppet:///modules/roles/ports_master/rsyncd.conf',
		# Needs to be at least number of direct mirrors plus some spare
		max_clients => 50,
		sslname     => 'ports-master.debian.org',
	}

	ssl::service { 'ports-master.debian.org':
		key => true,
	}

	vsftpd::site { 'ports-master':
		banner         => 'ports-master.debian.org FTP server',
		logfile        => '/var/log/ftp/vsftpd-ports-master.debian.org.log',
		writable       => true,
		writable_other => true,
		chown_user     => mini-dak-unpriv,
		root           => '/srv/ports-master.debian.org/ftp.upload',
	}
}
