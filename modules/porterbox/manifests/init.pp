class porterbox {
	include schroot

	file { '/etc/schroot/dsa':
		ensure => directory,
	}
	file { '/etc/schroot/dsa/config':
		source  => 'puppet:///modules/porterbox/schroot-dsa/config',
	}
	file { '/etc/schroot/dsa/default-mirror':
		content => template('porterbox/default-mirror.erb'),
	}
	file { '/etc/schroot/setup.d/99porterbox-extra-apt-options':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/schroot-setup.d/99porterbox-extra-apt-options',
	}
	file { '/etc/schroot/setup.d/99porterbox-extra-sources':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/schroot-setup.d/99porterbox-extra-sources',
	}
	file { '/usr/local/bin/dd-schroot-cmd':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/dd-schroot-cmd',
	}
	file { '/usr/local/sbin/setup-dchroot':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/setup-dchroot',
	}
}
