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
		banner       => 'ftp.debian.org FTP server',
		logfile      => '/var/log/ftp/vsftpd-ftp.debian.org.log',
		bind         => $bind,
		max_clients  => 200,
		root         => '/srv/ftp.debian.org/ftp.root',
	}

	if $bind6 {
		vsftpd::site { 'ftp-v6':
			banner       => 'ftp.debian.org FTP server',
			logfile      => '/var/log/ftp/vsftpd-ftp.debian.org.log',
			bind         => $bind6,
			max_clients  => 200,
			root         => '/srv/ftp.debian.org/ftp.root',
		}
	}
}
