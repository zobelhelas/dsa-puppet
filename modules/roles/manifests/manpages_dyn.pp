class roles::manpages_dyn {
	include apache2::ssl
	include apache2::proxy_http

	ssl::service { 'dyn.manpages.debian.org': notify  => Exec['service apache2 reload'], key => true, }

	apache2::site { 'dyn.manpages.debian.org':
		site   => 'dyn.manpages.debian.org',
		content => template('roles/manpages/dyn.manpages.debian.org.erb')
	}
}
