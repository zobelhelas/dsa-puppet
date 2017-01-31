class roles::cdimage_search {
	package { 'debian.org-cdimage-search.debian.org': ensure => installed, }

	apache2::site { '010-cdimage-search.debian.org':
		site   => 'cdimage-search.debian.org',
		content => template('roles/apache-cdimage-search.debian.org.conf.erb')
	}
}
