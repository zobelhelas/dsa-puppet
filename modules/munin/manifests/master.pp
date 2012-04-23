class munin::master {

	package { 'munin':
		ensure => installed
	}

	file { '/etc/munin/munin.conf':
		content => template('munin/munin.conf.erb'),
		require => Package['munin'];
	}
}
