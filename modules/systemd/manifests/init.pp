class systemd {
	file { '/etc/systemd/journald.conf':
		source => 'puppet:///modules/systemd/journald.conf',
	}
}
