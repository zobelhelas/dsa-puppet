class roles::ftp_upload {

	$bind = $::hostname ? {
		default => '',
	}

	$bind6 = $::hostname ? {
		default => '',
	}

	$logfile = '/var/log/ftp/vsftpd-ftp.upload.debian.org.log'

	vsftpd::site { 'ftp-upload':
		source  => template('roles/ftp_upload/vsftpd.conf.erb'),
		logfile => $logfile,
		bind    => $bind,
	}

	if $bind6 {
		vsftpd::site { 'ftp-upload-v6':
			source  => template('roles/ftp_upload/vsftpd.conf.erb'),
			logfile => $logfile,
			bind    => $bind6,
		}
	}
}
