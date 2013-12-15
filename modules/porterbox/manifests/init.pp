class porterbox {
	include schroot
	# FIXME: Refactor this to a common class when something else needs it
	package { 'moreutils':
		ensure => installed
	}

	file { '/etc/schroot/dsa':
		ensure => directory,
		require => Package['schroot'],
	}
	file { '/etc/schroot/dsa/config':
		source  => 'puppet:///modules/porterbox/schroot-dsa/config',
	}
	if ! ($::debarchitecture in ['kfreebsd-amd64', 'kfreebsd-i386']) {
		file { '/etc/schroot/dsa/fstab':
			source  => 'puppet:///modules/porterbox/schroot-dsa/fstab',
		}
	} else {
		file { '/etc/schroot/dsa/fstab':
			source  => 'puppet:///modules/porterbox/schroot-dsa/fstab-freebsd',
		}
	}
	file { '/etc/schroot/dsa/default-mirror':
		content => template('porterbox/default-mirror.erb'),
	}
	file { '/etc/schroot/setup.d/99porterbox-extra-apt-options':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/schroot-setup.d/99porterbox-extra-apt-options',
		require => Package['schroot'],
	}
	file { '/etc/schroot/setup.d/99porterbox-extra-sources':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/schroot-setup.d/99porterbox-extra-sources',
		require => Package['schroot'],
	}
	file { '/usr/local/bin/dd-schroot-cmd':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/dd-schroot-cmd',
	}
	file { '/usr/local/bin/schroot-list-sessions':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/schroot-list-sessions',
	}
	file { '/usr/local/sbin/setup-dchroot':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/setup-dchroot',
	}
	file { '/usr/local/sbin/setup-all-dchroots':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/setup-all-dchroots',
	}
	file { '/etc/cron.d/puppet-update-dchroots':
		content  => "0 15 * * 0 root PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin chronic setup-all-dchroots\n",
	}
	file { '/etc/cron.weekly/puppet-mail-big-homedirs':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/mail-big-homedirs',
	}
}
