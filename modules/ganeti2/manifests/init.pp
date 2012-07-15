class ganeti2 {

	package { 'ganeti2':
		ensure => installed
	}

	package { 'ganeti-instance-debootstrap':
		ensure => installed
	}

	package { 'ganeti-htools':
		ensure => installed
	}

	case $::cluster {
		'ganeti2.debian.org': {
			package { 'drbd8-utils':
				ensure => installed
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

			@ferm::rule { 'dsa-ganeti-drbd-v4':
				description => 'allow ganeti drbd communication',
				rule        => 'proto tcp mod state state (NEW) dport (11000:11999) @subchain \'ganeti-drbd\' { saddr ($HOST_GANETI_BACKEND_V4) daddr ($HOST_GANETI_BACKEND_V4) ACCEPT; }',
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
		}
	}

	file {
		'/etc/ganeti/instance-debootstrap/variants.list':
			content => template('ganeti2/instance-debootstrap/variants.list.erb'),
			;
		'/etc/ganeti/instance-debootstrap/variants/dsa.conf':
			content => template('ganeti2/instance-debootstrap/variants/dsa.conf.erb'),
			;
		'/etc/ganeti/instance-debootstrap/hooks/00-dsa-configure-networking':
			content => template('ganeti2/instance-debootstrap/hooks/00-dsa-configure-networking.erb'),
			mode   => '0555',
			;
		'/etc/ganeti/instance-debootstrap/hooks/10-dsa-install-extra-packages':
			content => template('ganeti2/instance-debootstrap/hooks/10-dsa-install-extra-packages.erb'),
			mode   => '0555',
			;
		'/etc/ganeti/instance-debootstrap/hooks/20-dsa-install-bootloader':
			content => template('ganeti2/instance-debootstrap/hooks/20-dsa-install-bootloader.erb'),
			mode   => '0555',
			;
		'/etc/ganeti/instance-debootstrap/hooks/30-dsa-install-ssh-keys':
			content => template('ganeti2/instance-debootstrap/hooks/30-dsa-install-ssh-keys.erb'),
			mode   => '0555',
			;
		'/etc/ganeti/instance-debootstrap/hooks/40-dsa-setup-swapfile':
			content => template('ganeti2/instance-debootstrap/hooks/40-dsa-setup-swapfile.erb'),
			mode   => '0555',
			;
		'/etc/ganeti/instance-debootstrap/hooks/clear-root-password':
			mode   => '0444',
			;
		'/etc/ganeti/instance-debootstrap/hooks/xen-hvc0':
			mode   => '0444',
			;
	}

}
