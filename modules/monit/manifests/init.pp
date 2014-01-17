# = Class: monit
#
# This class installs and configures monit
#
# == Sample Usage:
#
#   include monit
#
class monit {

	package { 'monit':
		ensure => installed
	}

	$cmd = $::lsbdistcodename ? {
		'sid'    => '/usr/bin/monit',
		'wheezy' => '/usr/bin/monit',
		default  => '/usr/sbin/monit',
	}

	augeas { 'inittab_monit':
		context => '/files/etc/inittab',
		changes => [
			'set mo/runlevels 2345',
			'set mo/action respawn',
			"set mo/process \"$cmd -d 300 -I -c /etc/monit/monitrc -s /var/lib/monit/monit.state\"",
		],
		notify => Exec['init q'],
	}

	file { '/etc/monit/':
		ensure  => directory,
		mode    => '0755',
		purge   => true,
		notify  => Exec['monit stop'],
		require => Package['monit'],
	}
	file { '/etc/monit/monit.d':
		ensure  => directory,
		mode    => '0750',
		purge   => true,
	}
	file { '/etc/monit/monitrc':
		content => template('monit/monitrc.erb'),
		mode    => '0400'
	}
	file { '/etc/monit/monit.d/01puppet':
		source  => 'puppet:///modules/monit/puppet',
		mode    => '0440'
	}
	file { '/etc/monit/monit.d/00debian.org':
		source  => 'puppet:///modules/monit/debianorg',
		mode    => '0440'
	}
	file { '/etc/default/monit':
		content => template('monit/default.erb'),
		require => Package['monit'],
		notify  => Exec['monit stop']
	}

	exec { 'monit stop':
		path        => '/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true,
	}
}
