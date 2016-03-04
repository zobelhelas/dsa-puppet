class munin {

	package { 'munin-node':
		ensure => installed
	}

	service { 'munin-node':
		ensure  => running,
		require => Package['munin-node'],
	}

	file { '/var/log/munin':
		ensure => directory,
		owner  => root,
		group  => 'www-data',
		mode   => '0755',
	}

	file { '/etc/munin/munin-node.conf':
		content => template('munin/munin-node.conf.erb'),
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}

	file { '/etc/munin/plugin-conf.d/munin-node':
		content => template('munin/munin-node.plugin.conf.erb'),
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}

	file { '/etc/logrotate.d/munin-node':
		source => 'puppet:///modules/munin/logrotate',
		require => Package['munin-node'],
	}

	file { '/etc/munin/plugins/df':
		ensure  => link,
		target  => '/usr/share/munin/plugins/df',
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}

	file { '/etc/munin/plugins/df_abs':
		ensure  => link,
		target  => '/usr/share/munin/plugins/df_abs',
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}

	file { '/etc/munin/plugins/df_inode':
		ensure  => link,
		target  => '/usr/share/munin/plugins/df_inode',
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}

	@ferm::rule { 'dsa-munin-v4':
		description     => 'Allow munin from munin master',
		rule            => 'proto tcp mod state state (NEW) dport (munin) @subchain \'munin\' { saddr ($HOST_MUNIN_V4 $HOST_NAGIOS_V4) ACCEPT; }',
		notarule        => true,
	}

	@ferm::rule { 'dsa-munin-v6':
		description     => 'Allow munin from munin master',
		domain          => 'ip6',
		rule            => 'proto tcp mod state state (NEW) dport (munin) @subchain \'munin\' { saddr ($HOST_MUNIN_V6 $HOST_NAGIOS_V6) ACCEPT; }',
		notarule        => true,
	}

	@@munin::master-per-node {
		$::fqdn:
			ipaddress   => $::ipaddress,
			munin_async => $::munin_async,
			;
	}

	#if $::munin_async and str2bool($::munin_async) == true {
	#	file { '/etc/ssh/userkeys/munin-async':
	#		source => 'puppet:///modules/munin/munin-async-authkeys',
	#	}
	#} else {
	#	file { '/etc/ssh/userkeys/munin-async':
	#		ensure => 'absent',
	#	}
	#}
	package { 'munin-async':
		ensure => installed
	}
	file { '/etc/ssh/userkeys/munin-async':
		source => 'puppet:///modules/munin/munin-async-authkeys',
	}
}
