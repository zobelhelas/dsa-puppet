class roles::ftp {

	$bind = $::hostname ? {
		klecker => '::ffff:130.89.148.12',
		default => '',
	}

	$bind6 = $::hostname ? {
		klecker => '2001:610:1908:b000::148:12',
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
