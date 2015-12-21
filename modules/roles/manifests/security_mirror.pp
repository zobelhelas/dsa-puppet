class roles::security_mirror {
	$rsync_bind = $::hostname ? {
		mirror-isc => '149.20.20.19',
		default    => '',
	}
	$rsync_bind6 = $::hostname ? {
		mirror-isc => '2001:4f8:8:36::1deb:19',
		default    => '',
	}

	include apache2::cache
	apache2::site { '010-security.debian.org':
		site   => 'security.debian.org',
		content => template('roles/security_mirror/security.debian.org.erb')
	}

	include ferm::ftp_conntrack
	vsftpd::site { 'security':
		banner       => 'security.debian.org FTP server (vsftpd)',
		logfile      => '/var/log/ftp/vsftpd-security.debian.org.log',
		max_clients  => 200,
		root         => '/srv/ftp.root/',
	}

	rsync::site { 'security':
		source      => 'puppet:///modules/roles/security_mirror/rsyncd.conf',
		max_clients => 100,
		bind        => $rsync_bind,
		bind6       => $rsync_bind6,
	}
}
