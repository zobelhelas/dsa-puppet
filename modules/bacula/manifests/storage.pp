class bacula::storage inherits bacula {

	package { 'bacula-sd':
		ensure => installed
	}

	service { 'bacula-sd':
		ensure    => running,
		enable    => true,
		hasstatus => true,
	}
	file { '/etc/bacula/bacula-sd.conf':
		content => template('bacula/bacula-sd.conf.erb'),
		mode    => '0640',
		group   => bacula,
		notify  => Service['bacula-sd']
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
}
