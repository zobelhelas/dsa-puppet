class bacula::director inherits bacula {
	bacula::node { $::fqdn: }

	package { ['bacula-director-pgsql', 'bacula-common', 'bacula-common-pgsql']:
		ensure => installed
	}

	service { 'bacula-director':
		ensure    => running,
		enable    => true,
		hasstatus => true,
		require   => Package['bacula-director-pgsql']
	}

	file { '/etc/bacula/conf.d':
		ensure  => directory,
		mode    => '0755',
		group   => bacula,
		purge   => true,
		force   => true,
		recurse => true,
		source  => 'puppet:///files/empty/',
		notify  => Service['bacula-director']
	}

	file { '/etc/bacula/bacula-dir.conf':
		content => template('bacula/bacula-dir.conf.erb'),
		mode    => '0440',
		group   => bacula,
		require => Package['bacula-director-pgsql'],
		notify  => Service['bacula-director']
	}

	@ferm::rule { 'dsa-bacula-dir':
		domain      => '(ip ip6)',
		description => 'Allow bacula access from localhost',
		rule        => "proto tcp mod state state (NEW) dport (bacula-dir) saddr (${bacula_director_address} localhost) ACCEPT",
	}

	file { '/etc/bacula/conf.d/empty.conf':
		content => '',
		mode    => '0440',
		group   => bacula,
		require => Package['bacula-director-pgsql'],
		notify  => Service['bacula-director']
	}

	Bacula::Node<<| |>>

	package { 'bacula-console':
		ensure => installed;
	}

	file { '/etc/bacula/bconsole.conf':
		content => template('bacula/bconsole.conf.erb'),
		mode    => '0640',
		group   => bacula,
		require => Package['bacula-console']
	}
}
