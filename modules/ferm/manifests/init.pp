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
	package { 'ulogd':
		ensure => installed
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
		source  => 'puppet:///modules/ferm/ferm.conf',
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
	file { '/etc/logrotate.d/ulogd':
		source  => 'puppet:///modules/ferm/logrotate-ulogd',
		mode    => '0444',
		require => Package['debian.org'],
	}

}
