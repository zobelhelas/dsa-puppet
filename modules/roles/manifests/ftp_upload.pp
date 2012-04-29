class roles::ftp_upload {

	$bind = $::hostname ? {
		kassia  => '::ffff:130.89.149.224',
		default => '',
	}

	$bind6 = $::hostname ? {
		kassia  => '2001:610:1908:a000:21b:78ff:fe75:3d46',
		default => '',
	}

	$logfile = '/var/log/ftp/vsftpd-ftp.upload.debian.org.log'

	vsftpd::site { 'ftp-upload':
		content => template('roles/ftp_upload/vsftpd.conf.erb'),
		logfile => $logfile,
		bind    => $bind,
	}

	if $bind6 {
		vsftpd::site { 'ftp-upload-v6':
			content => template('roles/ftp_upload/vsftpd.conf.erb'),
			logfile => $logfile,
			bind    => $bind6,
		}
	}
}
