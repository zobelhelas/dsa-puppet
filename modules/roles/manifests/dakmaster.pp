class roles::dakmaster {
	apache2::config { 'puppet-builddlist':
		content => template('roles/dakmaster/conf-builddlist.erb'),
	}

}
