class roles::security_mirror {
	$rsync_bind = $::hostname ? {
		mirror-anu => '150.203.164.39', # XXX this will change to 61
		mirror-isc => '149.20.20.19',
		mirror-umn => '128.101.240.215',
		default    => '',
	}
	$rsync_bind6 = $::hostname ? {
		mirror-anu => '2001:388:1034:2900::3d', # XXX this will change to 3d
		mirror-isc => '2001:4f8:8:36::1deb:19',
		mirror-umn => '2607:ea00:101:3c0b::1deb:215',
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
