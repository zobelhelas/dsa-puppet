class roles::security_mirror {

	apache2::site { '010-security.debian.org':
		site   => 'security.debian.org',
		config => 'puppet:///modules/roles/security_mirror/security.debian.org'
	}

	class { 'vsftpd::site':
		source => 'puppet:///modules/roles/security_mirror/vsftpd.conf'
	}
}
