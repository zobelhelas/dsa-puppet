class munin::master {

	package { 'munin':
		ensure => installed
	}

	file { '/etc/munin/munin.conf':
		content => template('munin/munin.conf.erb'),
		require => Package['munin'];
	}

	ssl::service { 'munin.debian.org':
		notify  => Exec['service apache2 reload'],
	}
	file { '/etc/munin/munin-conf.d':
		ensure  => directory,
		mode    => '0755',
		purge   => true,
		force   => true,
		recurse => true,
		source  => 'puppet:///files/empty/',
	}

	Munin::Master-per-node<<| |>>

	file { '/etc/cron.d/puppet-munin-cleanup':
		source => 'puppet:///modules/munin/master-cleanup-cron',
	}
}
