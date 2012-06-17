class roles::ftp-upcoming_mirror {

	apache2::site { '010-ftp-upcoming.debian.org':
		site   => 'ftp-upcoming.debian.org',
		source => 'puppet:///modules/roles/ftp-upcoming_mirror/ftp-upcoming.debian.org',
	}
}
