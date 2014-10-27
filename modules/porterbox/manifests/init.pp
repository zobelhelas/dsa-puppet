class porterbox ($ensure = present){
	if $ensure in present {
		include schroot
	}

	file { '/usr/local/bin/dd-schroot-cmd':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/dd-schroot-cmd',
		ensure => $ensure,
	}
	file { '/usr/local/bin/schroot-list-sessions':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/schroot-list-sessions',
		ensure => $ensure,
	}
	file { '/usr/local/sbin/setup-dchroot':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/setup-dchroot',
		ensure => $ensure,
	}
	file { '/usr/local/sbin/setup-all-dchroots':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/setup-all-dchroots',
		ensure => $ensure,
	}
	file { '/etc/cron.d/puppet-update-dchroots':
		content  => "0 15 * * 0 root PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin chronic setup-all-dchroots\n",
		ensure => $ensure,
	}
	file { '/etc/cron.weekly/puppet-mail-big-homedirs':
		mode    => '0555',
		source  => 'puppet:///modules/porterbox/mail-big-homedirs',
		ensure => $ensure,
	}
}
