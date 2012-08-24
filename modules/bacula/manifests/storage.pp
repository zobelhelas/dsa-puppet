class bacula::storage inherits bacula {

	package { 'bacula-sd':
		ensure => installed
	}

	service { 'bacula-sd':
		ensure    => running,
		enable    => true,
		hasstatus => true,
	}

	# should wait on -sd to finish current backups, then restart
	# since it does not support reload and restarting kills running
	# jobs
	exec { 'bacula-sd reload':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		command     => 'true',
		refreshonly => true,
	}

	file { '/etc/bacula/bacula-sd.conf':
		content => template('bacula/bacula-sd.conf.erb'),
		mode    => '0640',
		group   => bacula,
		notify  => Service['bacula-sd']
	}

	file { '/etc/bacula/storage-conf.d':
		ensure  => directory,
		mode    => '0755',
		group   => bacula,
		purge   => true,
		force   => true,
		recurse => true,
		source  => 'puppet:///files/empty/',
		notify  => Exec['bacula-sd reload']
	}

	@ferm::rule { 'dsa-bacula-sd-v4':
		domain      => '(ip)',
		description => 'Allow bacula-sd access from director and clients',
		rule        => 'proto tcp mod state state (NEW) dport (bacula-sd) @subchain \'bacula-sd\' { saddr ($HOST_DEBIAN_V4) ACCEPT; }',
		notarule    => true,
	}

	@ferm::rule { 'dsa-bacula-sd-v6':
		domain      => '(ip6)',
		description => 'Allow bacula-sd access from director and clients',
		rule        => 'proto tcp mod state state (NEW) dport (bacula-sd) @subchain \'bacula-sd\' { saddr ($HOST_DEBIAN_V6) ACCEPT; }',
		notarule    => true,
	}

	file { '/etc/bacula/storage-conf.d/empty.conf':
		content => '',
		mode    => '0440',
		group   => bacula,
		notify  => Exec['bacula-sd reload']
	}

	Bacula::Storage-per-Node<<| |>>

}
