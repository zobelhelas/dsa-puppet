class nagios::client inherits nagios {

	package { 'dsa-nagios-nrpe-config':
		ensure => purged
	}
	package { 'dsa-nagios-checks':
		ensure => installed,
		tag    => extra_repo,
	}

	service { 'nagios-nrpe-server':
		ensure    => running,
		hasstatus => false,
		pattern   => 'nrpe',
	}

	@ferm::rule { 'dsa-nagios-v4':
		description => 'Allow nrpe from nagios master',
		rule        => 'proto tcp mod state state (NEW) dport (5666) @subchain \'nagios\' { saddr ($HOST_NAGIOS_V4) ACCEPT; }',
		notarule    => true,
	}
	@ferm::rule { 'dsa-nagios-v6':
		description => 'Allow nrpe from nagios master',
		domain      => 'ip6',
		rule        => 'proto tcp mod state state (NEW) dport (5666) @subchain \'nagios\' { saddr ($HOST_NAGIOS_V6) ACCEPT; }',
		notarule    => true,
	}

	file { '/etc/default/nagios-nrpe-server':
		source  => 'puppet:///modules/nagios/common/default',
		require => Package['nagios-nrpe-server'],
		notify  => Service['nagios-nrpe-server'],
	}
	file { '/etc/default/nagios-nrpe':
		ensure  => absent,
		notify  => Service['nagios-nrpe-server'],
	}
	file { '/etc/nagios/':
		ensure  => directory,
		recurse => remote,
		source  => 'puppet:///files/empty/',
		require => Package['nagios-nrpe-server'],
		notify  => Service['nagios-nrpe-server'],
	}
	file { '/etc/nagios/nrpe.cfg':
		content => template('nagios/nrpe.cfg.erb'),
		notify  => Service['nagios-nrpe-server'],
	}
	file { '/etc/nagios/nrpe.d':
		ensure  => directory,
		recurse => remote,
		source  => 'puppet:///files/empty/',
		notify  => Service['nagios-nrpe-server'],
	}
	file { '/etc/nagios/nrpe.d/debianorg.cfg':
		content => template('nagios/inc-debian.org.erb'),
		notify  => Service['nagios-nrpe-server'],
	}
	file { '/etc/nagios/nrpe.d/nrpe_dsa.cfg':
		source  => 'puppet:///modules/nagios/dsa-nagios/generated/nrpe_dsa.cfg',
		notify  => Service['nagios-nrpe-server'],
	}
	file { '/etc/nagios/obsolete-packages-ignore':
		source  => 'puppet:///modules/nagios/common/obsolete-packages-ignore',
		require => Package['dsa-nagios-checks'],
	}
	file { '/etc/nagios/check-libs.conf':
		source  => 'puppet:///modules/nagios/common/check-libs.conf',
		require => Package['dsa-nagios-checks'],
	}
	file { '/etc/nagios/obsolete-packages-ignore.d/hostspecific':
		content => template('nagios/obsolete-packages-ignore.d-hostspecific.erb'),
		require => Package['dsa-nagios-checks'],
	}
	file { '/usr/local/sbin/dsa-check-libs':
		source  => 'puppet:///modules/nagios/dsa-check-libs',
		mode    => '0555',
	}

}
