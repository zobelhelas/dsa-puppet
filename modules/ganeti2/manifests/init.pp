class ganeti2 {

	include ganeti2::params
	include ganeti2::firewall

	$drbd = $ganeti2::params::drbd

	package { 'ganeti2':
		ensure => installed
	}

	package { 'ganeti-instance-debootstrap':
		ensure => installed
	}

	package { 'ganeti-htools':
		ensure => installed
	}

	if $drbd {
		package { 'drbd8-utils':
			ensure => installed
		}
	}

	file {
		'/etc/ganeti/instance-debootstrap/variants.list':
			content => template('ganeti2/instance-debootstrap/variants.list.erb'),
			;
		'/etc/ganeti/instance-debootstrap/variants/dsa.conf':
			content => template('ganeti2/instance-debootstrap/variants/dsa.conf.erb'),
			;
		'/etc/ganeti/instance-debootstrap/variants/dsa-wheezy.conf':
			content => template('ganeti2/instance-debootstrap/variants/dsa-wheezy.conf.erb'),
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
