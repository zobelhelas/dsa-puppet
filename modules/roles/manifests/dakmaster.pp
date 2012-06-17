class roles::dakmaster {

	package { 'libapache2-mod-macro':
		ensure => installed,
	}

	apache2::module { 'macro': }

	apache2::config { 'puppet-builddlist':
		content => template('roles/dakmaster/conf-builddlist.erb'),
	}

}
