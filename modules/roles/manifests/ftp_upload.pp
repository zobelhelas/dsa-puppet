class roles::ftp_upload {

	include ferm::ftp_conntrack

	vsftpd::site { 'ftp-upload':
		banner     => 'ftp.upload.debian.org FTP server',
		logfile    => '/var/log/ftp/vsftpd-ftp.upload.debian.org.log',
		writable   => true,
		chown_user => dak-unpriv,
		root       => '/srv/upload.debian.org/ftp',
	}

	if $bind6 {
		vsftpd::site { 'ftp-upload-v6':
			banner     => 'ftp.upload.debian.org FTP server',
			logfile    => '/var/log/ftp/vsftpd-ftp.upload.debian.org.log',
			writable   => true,
			chown_user => dak-unpriv,
			root       => '/srv/upload.debian.org/ftp',
		}
	}
}
