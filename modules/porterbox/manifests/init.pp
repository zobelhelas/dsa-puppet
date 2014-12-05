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
	file { '/etc/cron.d/puppet-update-dchroots':
		content  => "0 15 * * 0 root PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin setup-all-dchroots\n",
	}
	file { '/etc/cron.weekly/puppet-mail-big-homedirs':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/mail-big-homedirs',
	}
}
