class roles::ftp_upload {
	vsftpd::site { 'ftp-upload':
		source => 'puppet:///modules/roles/ftp_upload/vsftpd.conf'
	}
}
