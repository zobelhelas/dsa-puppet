class ganeti2::firewall {

	include ganeti2::params

	$ganeti_hosts = $ganeti2::params::ganeti_hosts
	$ganeti_priv  = $ganeti2::params::ganeti_priv
	$drbd         = $ganeti2::params::drbd

	@ferm::conf { 'ganeti2':
		content => template('ganeti2/defs.conf.erb')
	}

	@ferm::rule { 'dsa-ganeti-noded-v4':
		description => 'allow ganeti-noded communication',
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

	@ferm::rule { 'dsa-ganeti-kvm-migration-v4':
		description => 'allow ganeti kvm migration ',
		rule        => 'proto tcp dport 8102 @subchain \'ganeti-kvm-migration\' { saddr ($HOST_GANETI_BACKEND_V4) daddr ($HOST_GANETI_BACKEND_V4) ACCEPT; }',
		notarule    => true,
	}

	@ferm::rule { 'dsa-ganeti-ssh-v4':
		description => 'allow ganeti to ssh around',
		rule        => 'proto tcp dport ssh @subchain \'ganeti-ssh\' { saddr ( $HOST_GANETI_V4 $HOST_GANETI_BACKEND_V4) ACCEPT; }',
		notarule    => true,
	}

	if $drbd {
		@ferm::rule { 'dsa-ganeti-drbd-v4':
			description => 'allow ganeti drbd communication',
			rule        => 'proto tcp mod state state (NEW) dport (11000:11999) @subchain \'ganeti-drbd\' { saddr ($HOST_GANETI_BACKEND_V4) daddr ($HOST_GANETI_BACKEND_V4) ACCEPT; }',
			notarule    => true,
		}
	}
}
