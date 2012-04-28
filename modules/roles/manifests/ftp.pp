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

	$logfile = '/var/log/ftp/vsftpd-ftp.debian.org.log'

	vsftpd::site { 'ftp':
		source  => template('roles/ftp/vsftpd.conf.erb'),
		logfile => $logfile,
		bind    => $bind,
	}

	if $bind6 {
		vsftpd::site { 'ftp-v6':
			source  => template('roles/ftp/vsftpd.conf.erb'),
			logfile => $logfile,
			bind    => $bind6,
		}
	}
}
