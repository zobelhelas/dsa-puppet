# = Class: samhain
#
# This class installs and configures samhain
#
# == Sample Usage:
#
#   include samhain
#
class samhain {

	package { 'samhain':
		ensure => installed,
	}

	service { 'samhain':
		ensure    => running,
		hasstatus => false,
		pattern   => 'samhain',
		require   => Package['samhain'],
	}

	file { '/etc/samhain/samhainrc':
		content => template('samhain/samhainrc.erb'),
		require => Package['samhain'],
		notify  => Service['samhain']
	}
}
