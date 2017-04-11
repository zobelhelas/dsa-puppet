class roles::security_master {
	ssl::service { 'security-master.debian.org':
		notify   => Exec['service apache2 reload'],
		key      => true,
		tlsaport => [443, 1873],
	}

	vsftpd::site_systemd { 'security':
		banner     => 'security-master.debian.org FTP server (vsftpd)',
		logfile    => '/var/log/ftp/vsftpd-security-master.debian.org.log',
		writable   => true,
		chown_user => dak-unpriv,
		root       => '/srv/ftp.root/',
	}

	rsync::site { 'security_master':
		source      => 'puppet:///modules/roles/security_master/rsyncd.conf',
		max_clients => 100,
		sslname     => 'security-master.debian.org',
	}
}
