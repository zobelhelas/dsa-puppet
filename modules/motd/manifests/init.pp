# = Class: motd
#
# This class configures a sensible motd
#
# == Sample Usage:
#
#   include motd
#
class motd {
	if $::lsbmajdistrelease == "testing" or $::lsbmajdistrelease >= 7 {
		$fname  = '/etc/update-motd.d/puppet-motd'
		$notify = undef
		$mode   = '0555'

		file { '/etc/update-motd.d':
			ensure => directory,
			mode   => '0755'
		}
		file { '/etc/motd.tail':
			ensure => absent,
		}
	} else {
		$fname  = '/etc/motd.tail'
		$notify = Exec['updatemotd']
		$mode   = '0444'

	}

	file { '/etc/motd':
		ensure => link,
		target => '/var/run/motd'
	}

	file { $fname:
		notify  => $notify,
		mode    => $mode,
		content => template('motd/motd.erb')
	}

	exec { 'updatemotd':
		command     => 'uname -snrvm > /var/run/motd && cat /etc/motd.tail >> /var/run/motd',
		refreshonly => true,
	}
}
