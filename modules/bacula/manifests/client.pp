class bacula::client inherits bacula {
	@@bacula::storage-per-node { $::fqdn: }

	if ! getfromhash($site::nodeinfo, 'not-bacula-client') {
		@@bacula::node { $::fqdn: }
	}

	package { ['bacula-fd']:
		ensure => installed
	}

	service { 'bacula-fd':
		ensure    => running,
		enable    => true,
		hasstatus => true,
		require   => Package['bacula-fd']
	}

	exec { 'bacula-fd restart-when-idle':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		command     => 'sh -c "setsid /usr/local/sbin/bacula-idle-restart fd &"',
		refreshonly => true,
		subscribe   => [ File[$bacula_ssl_server_cert], File[$bacula_ssl_client_cert] ],
		require     => File['/usr/local/sbin/bacula-idle-restart'],
	}

	file { '/etc/bacula/bacula-fd.conf':
		content => template('bacula/bacula-fd.conf.erb'),
		mode    => '0640',
		owner   => root,
		group   => bacula,
		require => Package['bacula-fd'],
		notify  => Exec['bacula-fd restart-when-idle'],
	}
	file { '/usr/local/sbin/bacula-backup-dirs':
		mode    => '0775',
		source  => 'puppet:///modules/bacula/bacula-backup-dirs',
	}
	file { '/usr/local/sbin/postbaculajob':
		mode    => '0775',
		source  => 'puppet:///modules/bacula/postbaculajob',
	}
	file { '/etc/default/bacula-fd':
		content => template('bacula/default.bacula-fd.erb'),
		mode    => '0400',
		owner   => root,
		group   => root,
		require => Package['bacula-fd'],
		notify  => Service['bacula-fd'],
	}
	if $::lsbmajdistrelease < 7 {
		file { '/etc/apt/preferences.d/dsa-bacula-client':
			content => template('bacula/apt.preferences.bacula-client.erb'),
			mode    => '0444',
			owner   => root,
			group   => root,
		}
	} else {
		file { '/etc/apt/preferences.d/dsa-bacula-client':
			ensure => absent
		}
	}

	@ferm::rule { 'dsa-bacula-fd-v4':
		domain      => '(ip)',
		description => 'Allow bacula access from storage and director',
		rule        => "proto tcp mod state state (NEW) dport (bacula-fd) saddr (${bacula_director_ip}) ACCEPT",
	}

	#@ferm::rule { 'dsa-bacula-fd-v6':
	#	domain      => '(ip6)',
	#	description => 'Allow bacula access from storage and director',
	#	rule        => "proto tcp mod state state (NEW) dport (bacula-fd) saddr (${bacula_director_ip6}) ACCEPT",
	#}
}
