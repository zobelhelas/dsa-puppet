class roles::cdimage_search {
	include apache2::proxy_http
	include apache2::ssl

	package { 'debian.org-cdimage-search.debian.org': ensure => installed, }

	ssl::service { 'cdimage-search.debian.org': notify  => Exec['service apache2 reload'], key => true, }
	apache2::site { '010-cdimage-search.debian.org':
		site   => 'cdimage-search.debian.org',
		content => template('roles/apache-cdimage-search.debian.org.conf.erb')
	}

	onion::service { 'cdimage-search.debian.org': port => 80, target_address => 'cdimage-search.debian.org', target_port => 80, direct => true }
}
