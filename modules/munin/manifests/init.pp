class munin {

	package { 'munin-node':
		ensure => installed
	}

	service { 'munin-node':
		ensure  => running,
		require => Package['munin-node'],
	}

	$owner = $::lsbdistcodename ? {
		squeeze => munin,
		wheezy  => root
	}

	$gid = $::lsbdistcodename ? {
		squeeze => adm,
		wheezy  => 'www-data',
	}

	file { '/var/log/munin':
		ensure => directory,
		owner  => $owner,
		group  => $gid,
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

	file { [ '/etc/munin/plugins/df', '/etc/munin/plugins/df_abs', '/etc/munin/plugins/df_inode' ]:
		source => 'puppet:///modules/munin/df-wrap',
		mode    => '0555',
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
}
