class nfs-server {

	package { [
			'nfs-common',
			'nfs-kernel-server'
		]:
			ensure => installed
	}

	service { 'nfs-common':
		hasstatus   => false,
		status      => '/bin/true',
		refreshonly => true,
	}
	service { 'nfs-kernel-server':
		hasstatus   => false,
		status      => '/bin/true',
		refreshonly => true,
	}

	@ferm::rule { 'dsa-portmap':
		domain      => '(ip ip6)',
		description => 'Allow portmap access',
		rule        => '&TCP_UDP_SERVICE(111)'
	}
	@ferm::rule { 'dsa-nfs':
		domain      => '(ip ip6)',
		description => 'Allow nfsd access',
		rule        => '&TCP_UDP_SERVICE(2049)'
	}
	@ferm::rule { 'dsa-status':
		domain      => '(ip ip6)',
		description => 'Allow statd access',
		rule        => '&TCP_UDP_SERVICE(10000)'
	}
	@ferm::rule { 'dsa-mountd':
		domain      => '(ip ip6)',
		description => 'Allow mountd access',
		rule        => '&TCP_UDP_SERVICE(10002)'
	}
	@ferm::rule { 'dsa-lockd':
		domain      => '(ip ip6)',
		description => 'Allow lockd access',
		rule        => '&TCP_UDP_SERVICE(10003)'
	}

	file { '/etc/default/nfs-common':
		source  => 'puppet:///modules/nfs-server/nfs-common.default',
		require => Package['nfs-common'],
		notify  => Service['nfs-common'],
	}
	file { '/etc/default/nfs-kernel-server':
		source  => 'puppet:///modules/nfs-server/nfs-kernel-server.default',
		require => Package['nfs-kernel-server'],
		notify  => Service['nfs-kernel-server'],
	}
	file { '/etc/modprobe.d/lockd.local':
		source => 'puppet:///modules/nfs-server/lockd.local.modprobe'
	}
}
