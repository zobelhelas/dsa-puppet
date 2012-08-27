class munin::master {

	package { 'munin':
		ensure => installed
	}

	file { '/etc/munin/munin.conf':
		content => template('munin/munin.conf.erb'),
		require => Package['munin'];
	}

	if $::hostname == 'menotti' {
		file { '/etc/munin/munin-conf.d':
			ensure => directory,
			mode   => 755,
			;
		}

		Munin::Master-per-node<<| |>>
	}
}
