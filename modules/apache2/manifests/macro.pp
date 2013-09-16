class apache2::macro {
	package { 'libapache2-mod-macro':
		ensure => installed
	}

	apache2::module { 'macro':
		require => Package['libapache2-mod-macro']
	}
}
