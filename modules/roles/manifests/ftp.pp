class roles::ftp {

	$bind = $::hostname ? {
		default => '',
	}

	$bind6 = $::hostname ? {
		default => '',
	}

	vsftpd::site { 'ftp':
		source => 'puppet:///modules/roles/ftp/vsftpd.conf',
		bind   => $bind,
	}

	if $bind6 {
		vsftpd::site { 'security-v6':
			source => 'puppet:///modules/roles/security_mirror/vsftpd.conf',
			bind   => $bind6,
		}
	}
}
