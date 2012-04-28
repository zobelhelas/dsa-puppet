class roles::ftp {

	$bind = $::hostname ? {
		kassia  => '::ffff:130.89.149.226',
		klecker => '::ffff:130.89.148.12',
		default => '',
	}

	$bind6 = $::hostname ? {
		kassia  => '2001:610:1908:a000::149:226',
		klecker => '2001:610:1908:b000::148:12',
		default => '',
	}

	vsftpd::site { 'ftp':
		source  => 'puppet:///modules/roles/ftp/vsftpd.conf',
		logfile => '/var/log/ftp/vsftpd-ftp.debian.org.log',
		bind    => $bind,
	}

	if $bind6 {
		vsftpd::site { 'ftp-v6':
			source  => 'puppet:///modules/roles/security_mirror/vsftpd.conf',
			logfile => '/var/log/ftp/vsftpd-ftp.debian.org.log',
			bind    => $bind6,
		}
	}
}
