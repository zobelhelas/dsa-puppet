class syslog-ng {
	package { 'syslog-ng':
		ensure => installed
	}

	service { 'syslog-ng':
		ensure => running,
		hasstatus => false,
		pattern   => 'syslog-ng',
	}

	file { '/etc/syslog-ng/syslog-ng.conf':
		content => template('syslog-ng/syslog-ng.conf.erb'),
		require => Package['syslog-ng'],
		notify  => Service['syslog-ng']
	}
	file { '/etc/default/syslog-ng':
		source  => 'puppet:///modules/syslog-ng/syslog-ng.default',
		require => Package['syslog-ng'],
		notify  => Service['syslog-ng']
	}
	file { '/etc/logrotate.d/syslog-ng':
		source  => 'puppet:///modules/syslog-ng/syslog-ng.logrotate',
		require => Package['syslog-ng']
	}
	if $::hostname in [lotty,lully] {
		file { '/etc/logrotate.d/syslog-ng-loggers':
			source  => 'puppet:///modules/syslog-ng/syslog-ng.logrotate.loggers',
			require => Package['syslog-ng']
		}
	}
}
