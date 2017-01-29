class roles::ports_master {
	rsync::site { 'ports-master':
		source      => 'puppet:///modules/roles/ports_master/rsyncd.conf',
		max_clients => 100,
		sslname     => 'ports-master.debian.org',
	}

	ssl::service { 'ports-master.debian.org':
		key => true,
	}

	include ferm::ftp_conntrack

	vsftpd::site { 'ports-master':
		banner         => 'ports-master.debian.org FTP server',
		logfile        => '/var/log/ftp/vsftpd-ports-master.debian.org.log',
		writable       => true,
		writable_other => true,
		chown_user     => mini-dak-unpriv,
		root           => '/srv/ports-master.debian.org/ftp.upload',
	}

	if $bind6 {
		vsftpd::site { 'ports-master-v6':
			banner         => 'ports-master.debian.org FTP server',
			logfile        => '/var/log/ftp/vsftpd-ports-master.debian.org.log',
			writable       => true,
			writable_other => true,
			chown_user     => mini-dak-unpriv,
			root           => '/srv/ports-master.debian.org/ftp.upload',
		}
	}
}
