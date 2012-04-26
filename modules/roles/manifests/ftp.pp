class roles::ftp {
	vsftpd::site { 'ftp':
		source => 'puppet:///modules/roles/ftp/vsftpd.conf'
	}
}
