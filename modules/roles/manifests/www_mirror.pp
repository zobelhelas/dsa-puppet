class roles::www_mirror {
	# see also static mirrors.

	$wwwdo_document_root = '/srv/www.debian.org/www'
	apache2::site { '010-www.debian.org':
		site   => 'www.debian.org',
		content => template('roles/apache-www.debian.org.erb'),
	}
}
