class roles::debtags {
	apache2::module { 'ssl': }
	package { 'libapache2-mod-wsgi': ensure => installed, }

	ssl::service { 'debtags.debian.org':
		notify => Service['apache2'],
	}

	apache2::site { '010-debtags.debian.org':
		site    => 'debtags.debian.org',
		source => 'puppet:///modules/roles/debtags/debtags.debian.org',
	}
}
