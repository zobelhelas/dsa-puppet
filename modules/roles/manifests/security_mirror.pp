class roles::security_mirror {
	$rsync_bind = $::hostname ? {
		mirror-anu => '150.203.164.61',
		mirror-isc => '149.20.20.19',
		mirror-umn => '128.101.240.215',
		default    => '',
	}
	$rsync_bind6 = $::hostname ? {
		mirror-anu => '2001:388:1034:2900::3d',
		mirror-isc => '2001:4f8:8:36::1deb:19',
		mirror-umn => '2607:ea00:101:3c0b::1deb:215',
		default    => '',
	}
	$ftp_bind = $::hostname ? {
		mirror-anu => '150.203.164.61',
		default => '',
	}
	$ftp_bind6 = $::hostname ? {
		mirror-anu => '2001:388:1034:2900::3d',
		default => undef,
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
		bind         => $ftp_bind,
	}
	if ($ftp_bind6) {
		vsftpd::site { 'security6':
			banner       => 'security.debian.org FTP server (vsftpd)',
			logfile      => '/var/log/ftp/vsftpd-security6.debian.org.log',
			max_clients  => 200,
			root         => '/srv/ftp.root/',
			bind         => $ftp_bind6,
		}
	}

	rsync::site { 'security':
		source      => 'puppet:///modules/roles/security_mirror/rsyncd.conf',
		max_clients => 100,
		bind        => $rsync_bind,
		bind6       => $rsync_bind6,
	}


	$onion_v4_addr = $::hostname ? {
		mirror-anu => '150.203.164.61',
		mirror-isc => '149.20.20.19',
		mirror-umn => '128.101.240.215',
		villa      => '212.211.132.32',
		lobos      => '212.211.132.250',
		default   => undef,
	}
	if has_role('security_mirror_onion') {
		if ! $onion_v4_addr {
			fail("Do not have an onion_v4_addr set for $::hostname.")
		}

		onion::service { 'security.debian.org':
			port => 80,
			target_port => 80,
			target_address => $onion_v4_addr,
		}
	}
}
