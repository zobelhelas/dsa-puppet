class schroot {
	package { 'schroot':
		ensure => installed,
		tag    => extra_repo,
	}
	package { 'debootstrap':
		ensure => installed,
	}
	package { 'moreutils':
		ensure => installed
	}

	file { '/etc/default/schroot':
		source  => 'puppet:///modules/schroot/default-schroot',
		require => Package['schroot']
	}

	file { '/etc/schroot/mount-defaults':
		ensure => absent,
	}
	file { '/etc/schroot/default/nssdatabases':
		source  => 'puppet:///modules/schroot/nssdatabases',
		require => Package['schroot']
	}

	file { '/etc/schroot/setup.d/99porterbox-extra-apt-options':
		mode    => '0555',
		source  => 'puppet:///modules/schroot/schroot-setup.d/99porterbox-extra-apt-options',
		require => Package['schroot'],
	}
	file { '/etc/schroot/setup.d/99porterbox-extra-sources':
		mode    => '0555',
		source  => 'puppet:///modules/schroot/schroot-setup.d/99porterbox-extra-sources',
		require => Package['schroot'],
	}

	file { '/etc/schroot/dsa':
		ensure => directory,
		require => Package['schroot'],
	}
	file { '/etc/schroot/dsa/default-mirror':
		content => template('schroot/default-mirror.erb'),
	}
	file { '/etc/schroot/dsa/config':
		source  => 'puppet:///modules/schroot/schroot-dsa/config',
	}
	file { '/etc/schroot/dsa/fstab':
		content => template('schroot/schroot-dsa/fstab.erb'),
		require => Package['schroot'],
	}

	file { '/etc/schroot/buildd/fstab':
		content => template('schroot/schroot-buildd/fstab.erb'),
		require => Package['schroot'],
	}
}
