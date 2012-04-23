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

	@ferm::rule { 'dsa-ganeti-noded-v4':
		description => 'allow ganeti-noded communication between',
		rule        => 'proto tcp mod state state (NEW) dport (1811) @subchain \'ganeti-noded\' { saddr ($HOST_GANETI_V4) daddr ($HOST_GANETI_V4) ACCEPT; }',
		notarule    => true,
	}

	@ferm::rule { 'dsa-ganeti-confd-v4':
		description => 'allow ganeti-confd communication',
		rule        => 'proto udp mod state state (NEW) dport (1814) @subchain \'ganeti-confd\' { saddr ($HOST_GANETI_V4) daddr ($HOST_GANETI_V4) ACCEPT; }',
		notarule    => true,
	}

	@ferm::rule { 'dsa-ganeti-rapi-v4':
		description => 'allow ganeti-rapi communication',
		rule        => 'proto tcp mod state state (NEW) dport (5080) @subchain \'ganeti-rapi\' { saddr ($HOST_GANETI_V4) daddr ($HOST_GANETI_V4) ACCEPT; }',
		notarule    => true,
	}

	@ferm::rule { 'dsa-drbd-v4':
		description => 'allow drbd communication',
		rule        => 'proto tcp mod state state (NEW) dport (11000:11999) @subchain \'drbd\' { saddr ($HOST_DRBD_V4) daddr ($HOST_DRBD_V4) ACCEPT; }',
		notarule    => true,
	}
}
