class ganeti2 {

	package { 'ganeti2':
		ensure => installed
	}

	package { 'drbd8-utils':
		ensure => installed
	}

	package { 'ganeti-instance-debootstrap':
		ensure => installed
	}

	package { 'ganeti-htools':
		ensure => installed
	}

	@ferm::rule { 'dsa-ganeti-v4':
		description => 'Allow ganeti from ganeti master',
		rule        => 'proto tcp mod state state (NEW) dport (1811) @subchain \'ganeti\' { saddr ($HOST_GANETI_V4) ACCEPT; }',
		notarule    => true,
	}

	@ferm::rule { 'dsa-drbd-v4':
		description => 'Allow ganeti from ganeti master',
		rule        => 'proto tcp mod state state (NEW) dport (11000:11999) @subchain \'drbd\' { saddr ($HOST_DRBD_V4) daddr ($HOST_DRBD_4) ACCEPT; }',
		notarule    => true,
	}
}
