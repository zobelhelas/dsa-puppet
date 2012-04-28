class roles::security_mirror {

	apache2::site { '010-security.debian.org':
		site   => 'security.debian.org',
		config => 'puppet:///modules/roles/security_mirror/security.debian.org'
	}

	$bind = $::hostname ? {
		default => '',
	}

	$bind6 = $::hostname ? {
		default => '',
	}

	vsftpd::site { 'security':
		source  => 'puppet:///modules/roles/security_mirror/vsftpd.conf',
		logfile => '/var/log/ftp/vsftpd-security.debian.org.log',
		bind    => $bind,
	}

	if $bind6 {
		vsftpd::site { 'security-v6':
			source  => 'puppet:///modules/roles/security_mirror/vsftpd.conf',
			logfile => '/var/log/ftp/vsftpd-security.debian.org.log',
			bind    => $bind6,
		}
	}

}
