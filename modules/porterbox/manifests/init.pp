class porterbox {
	include schroot

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
