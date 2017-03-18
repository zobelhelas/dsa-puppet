# = Class: ferm
#
# This class installs ferm and sets up rules
#
# == Sample Usage:
#
#   include ferm
#
class ferm {
	# realize (i.e. enable) all @ferm::rule virtual resources
	Ferm::Rule <| |>
	Ferm::Conf <| |>

	File { mode => '0400' }

	package { 'ferm':
		ensure => installed
	}
	if ($::lsbmajdistrelease >= '8') {
		package { 'ulogd2':
			ensure => installed
		}
		package { 'ulogd':
			# Remove instead of purge ulogd because it deletes log files on purge.
			ensure => absent
		}
	} else {
		package { 'ulogd':
			ensure => installed
		}
	}

	service { 'ferm':
		hasstatus   => false,
		status      => '/bin/true',
	}

	$munin_ips = split(regsubst($::v4ips, '([^,]+)', 'ip_\1', 'G'), ',')

	munin::check { $munin_ips: script => 'ip_', }

	if $v6ips {
		$munin6_ips = split(regsubst($::v6ips, '([^,]+)', 'ip_\1', 'G'), ',')
		munin::ipv6check { $munin6_ips: }
	}

	# get rid of old stuff
	$munin6_ip6s = split(regsubst($::v6ips, '([^,]+)', 'ip6_\1', 'G'), ',')
	munin::check { $munin6_ip6s: ensure => absent }

	file { '/etc/ferm':
		ensure  => directory,
		notify  => Service['ferm'],
		require => Package['ferm'],
		mode    => '0755'
	}
	file { '/etc/ferm/dsa.d':
		ensure => directory,
		mode   => '0555',
		purge   => true,
		force   => true,
		recurse => true,
		source  => 'puppet:///files/empty/',
	}
	file { '/etc/ferm/conf.d':
		ensure => directory,
		mode   => '0555',
		purge   => true,
		force   => true,
		recurse => true,
		source  => 'puppet:///files/empty/',
	}
	file { '/etc/default/ferm':
		source  => 'puppet:///modules/ferm/ferm.default',
		require => Package['ferm'],
		notify  => Service['ferm'],
		mode    => '0444',
	}
	file { '/etc/ferm/ferm.conf':
		content => template('ferm/ferm.conf.erb'),
		notify  => Service['ferm'],
	}
	file { '/etc/ferm/conf.d/me.conf':
		content => template('ferm/me.conf.erb'),
		notify  => Service['ferm'],
	}
	file { '/etc/ferm/conf.d/defs.conf':
		content => template('ferm/defs.conf.erb'),
		notify  => Service['ferm'],
	}
	file { '/etc/ferm/conf.d/interfaces.conf':
		content => template('ferm/interfaces.conf.erb'),
		notify  => Service['ferm'],
	}
	if ($::lsbmajdistrelease >= '8') {
		augeas { 'logrotate_ulogd2':
			context => '/files/etc/logrotate.d/ulogd2',
			changes => [
				'set rule/schedule daily',
				'set rule/delaycompress delaycompress',
				'set rule/rotate 10',
				'set rule/ifempty notifempty',
			],
		}
		file { '/etc/logrotate.d/ulogd':
			ensure  => absent,
		}
		file { '/etc/logrotate.d/ulogd.dpkg-bak':
			ensure  => absent,
		}
		file { '/etc/logrotate.d/ulogd.dpkg-dist':
			ensure  => absent,
		}
	} else {
		file { '/etc/logrotate.d/ulogd':
			source  => 'puppet:///modules/ferm/logrotate-ulogd',
			mode    => '0444',
			require => Package['debian.org'],
		}
	}

}
