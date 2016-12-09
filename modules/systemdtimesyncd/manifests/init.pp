class systemdtimesyncd {
	$localtimeservers = hiera('local-timeservers', [])

	if (! $systemd) {
		fail ( "systemdtimesyncd requires systemd." )
	} elsif (size($localtimeservers) == 0) {
		fail ( "No local timeservers configured for systemdtimesyncd." )
	} else {
		file { '/etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service':
			ensure => 'absent',
			notify => Exec['systemctl daemon-reload'],
		}
		file { '/etc/systemd/system/multi-user.target.wants':
			ensure => 'directory',
		}
		file { '/etc/systemd/system/multi-user.target.wants/systemd-timesyncd.service':
			ensure => 'link',
			target => '/lib/systemd/system/systemd-timesyncd.service',
			notify => Exec['systemctl daemon-reload'],
		}

		service { 'systemd-timesyncd':
			ensure  => running,
		}

		file { '/etc/systemd/timesyncd.conf':
			content => template('systemdtimesyncd/timesyncd.conf.erb'),
			notify  => Service['systemd-timesyncd'],
		}
	}
}
