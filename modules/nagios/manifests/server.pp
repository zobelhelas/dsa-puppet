class nagios::server {

	package { [
			'nagios3',
			'nagios-nrpe-plugin',
			'nagios-plugins',
			'nagios-images'
		]:
		ensure => installed
	}

	service { 'nagios3':
		ensure => running,
	}

	file { '/etc/nagios-plugins/config':
		ensure  => directory,
		recurse => remote,
		source  => 'puppet:///files/empty/',
		require => Package['nagios3'],
		notify  => Service['nagios3'],
	}
	file { '/etc/nagios3':
		ensure  => directory,
		recurse => remote,
		source  => 'puppet:///files/empty/',
		require => Package['nagios3'],
		notify  => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d':
		ensure => directory,
		recurse => remote,
		source  => 'puppet:///files/empty/',
		require => Package['nagios3'],
		notify  => Service['nagios3'],
	}
	file { '/etc/nagios-plugins/config/local-dsa-checkcommands.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/static/checkcommands.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios-plugins/config/local-dsa-eventhandlers.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/static/eventhandlers.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/cgi.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/static/cgi.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/nagios.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/static/nagios.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/contacts.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/static/conf.d/contacts.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/generic-host.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/static/conf.d/generic-host.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/generic-service.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/static/conf.d/generic-service.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/timeperiods.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/static/conf.d/timeperiods.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/auto-dependencies.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/generated/auto-dependencies.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/auto-hostextinfo.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/generated/auto-hostextinfo.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/auto-hostgroups.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/generated/auto-hostgroups.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/auto-hosts.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/generated/auto-hosts.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/auto-serviceextinfo.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/generated/auto-serviceextinfo.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/auto-servicegroups.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/generated/auto-servicegroups.cfg',
		notify => Service['nagios3'],
	}
	file { '/etc/nagios3/puppetconf.d/auto-services.cfg':
		source => 'puppet:///modules/nagios/dsa-nagios/generated/auto-services.cfg',
		notify => Service['nagios3'],
	}
}
