class porterbox {
	include schroot

	file { '/etc/schroot/dsa':
		ensure => directory,
		require => Package['schroot'],
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
		require => Package['schroot'],
	}
	file { '/etc/schroot/setup.d/99porterbox-extra-sources':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/schroot-setup.d/99porterbox-extra-sources',
		require => Package['schroot'],
	}
	file { '/usr/local/bin/dd-schroot-cmd':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/dd-schroot-cmd',
	}
	file { '/usr/local/bin/schroot-list-sessions':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/schroot-list-sessions',
	}
	file { '/usr/local/sbin/setup-dchroot':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/setup-dchroot',
	}
	file { '/usr/local/sbin/setup-all-dchroots':
		mode    => 555,
		source  => 'puppet:///modules/porterbox/setup-all-dchroots',
	}
	file { '/etc/cron.d/puppet-update-dchroots':
		content  => "0 15 * * 0 root PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin chronic setup-all-dchroots\n",
	}
}
