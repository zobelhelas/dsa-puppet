class roles::security_mirror {

	apache2::site { '010-security.debian.org':
		site   => 'security.debian.org',
		config => 'puppet:///modules/roles/security_mirror/security.debian.org'
	}

	apache2::site { 'security.debian.org':
		ensure => absent,
	}
}
