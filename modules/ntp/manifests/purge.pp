class ntp::purge {
	package { 'ntp':
		ensure => purged
	}

	file { '/etc/init.d/ntp':
		ensure => absent,
	}
	file { '/etc/ntp.conf':
		ensure => absent,
	}
	file { '/etc/default/ntp':
		ensure => absent,
	}

	file { '/var/lib/ntp':
		ensure  => absent,
		recurse => true,
		purge => true,
		force => true,
	}
	file { '/etc/ntp.keys.d':
		ensure  => absent,
		recurse => true,
		purge => true,
		force => true,
	}

	file { '/etc/munin/plugins/ntp_kernel_err':
		ensure => absent,
	}
	file { '/etc/munin/plugins/ntp_offset':
		ensure => absent,
	}
	file { '/etc/munin/plugins/ntp_states':
		ensure => absent,
	}
	file { '/etc/munin/plugins/ntp_kernel_pll_off':
		ensure => absent,
	}
	file { '/etc/munin/plugins/ntp_kernel_pll_freq':
		ensure => absent,
	}
}
