class roles::ftp_upload {

	$bind = $::hostname ? {
		default => '',
	}

	$bind6 = $::hostname ? {
		default => '',
	}

	vsftpd::site { 'ftp-upload':
		source => 'puppet:///modules/roles/ftp_upload/vsftpd.conf',
		bind   => $bind,
	}

	if $bind6 {
		vsftpd::site { 'ftp-upload-v6':
			source => 'puppet:///modules/roles/security_mirror/vsftpd.conf',
			bind   => $bind6,
		}
	}
}
