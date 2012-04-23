# = Class: motd
#
# This class configures a sensible motd
#
# == Sample Usage:
#
#   include motd
#
class motd {

	file { '/etc/motd.tail':
		notify  => Exec['updatemotd'],
		content => template('motd/motd.erb')
	}
	file { '/etc/motd':
		ensure => link,
		target => '/var/run/motd'
	}

	exec { 'updatemotd':
		command     => 'uname -snrvm > /var/run/motd && cat /etc/motd.tail >> /var/run/motd',
		refreshonly => true,
	}
}
