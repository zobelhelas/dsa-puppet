# = Class: motd
#
# This class configures a sensible motd
#
# == Sample Usage:
#
#   include motd
#
class motd {

	if $::lsbdistcodename == 'wheezy' {
		$fname  = '/etc/update-motd.d/puppet-motd'
		$notify = undef
		$mode   = '0555'

		file { '/etc/motd':
			ensure  => present,
			replace => false
		}

	} elsif $::lsbdistcodename == 'squeeze' {
		$fname  = '/etc/motd.tail'
		$notify = Exec['updatemotd']
		$mode   = '0444'

		file { '/etc/motd':
			ensure => link,
			target => '/var/run/motd'
		}
		exec { 'updatemotd':
			command     => 'uname -snrvm > /var/run/motd && cat /etc/motd.tail >> /var/run/motd',
			refreshonly => true,
		}
	}

	file { $fname:
		notify  => $notify,
		mode    => $mode,
		content => template('motd/motd.erb')
	}
}
