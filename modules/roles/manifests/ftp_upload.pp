class roles::ftp_upload {
	vsftpd::site_systemd { 'ftp-upload':
		banner     => 'ftp.upload.debian.org FTP server',
		logfile    => '/var/log/ftp/vsftpd-ftp.upload.debian.org.log',
		writable   => true,
		chown_user => dak-unpriv,
		root       => '/srv/upload.debian.org/ftp',
	}
}
