class bacula::client inherits bacula {
	@@bacula::storage-per-node { $::fqdn: }

	if $::hostname in [beethoven, berlioz, biber, diabelli, dinis, draghi, geo3, schumann, soler, widor, wolkenstein] {
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

	file {
		'/etc/bacula/bacula-fd.conf':
			content => template('bacula/bacula-fd.conf.erb'),
			mode    => '0640',
			owner   => root,
			group   => bacula,
			require => Package['bacula-fd'],
			notify  => Service['bacula-fd'],
			;
		'/usr/local/sbin/postbaculajob':
			mode    => '0775',
			source  => 'puppet:///modules/bacula/postbaculajob',
			;
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
