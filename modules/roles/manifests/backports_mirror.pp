class roles::backports_mirror {
	apache2::site { '010-backports.debian.org':
		site   => 'backports.debian.org',
		source => 'puppet:///modules/roles/backports_mirror/backports.debian.org',
	}

	apache2::site { '010-www.backports.org':
		site   => 'www.backports.org',
		source => 'puppet:///modules/roles/backports_mirror/www.backports.org',
	}

	apache2::module { 'rewrite': }

}
