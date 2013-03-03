class schroot {
	package { 'schroot':
		ensure => installed,
		tag    => extra_repo,
	}
	package { 'debootstrap':
		ensure => installed,
	}

	file { '/etc/schroot/mount-defaults':
		content => template('schroot/etc/schroot/mount-defaults.erb'),
		require => Package['sbuild'],
	}
	file { '/etc/default/schroot':
		source  => 'puppet:///modules/schroot/default-schroot',
		require => Package['schroot']
	}
}
