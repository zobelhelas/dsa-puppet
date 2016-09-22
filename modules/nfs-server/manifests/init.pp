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
	}
	service { 'nfs-kernel-server':
		hasstatus   => false,
		status      => '/bin/true',
	}

	case $::hostname {
		lw01,lw02,lw03,lw04: {
			$client_range    = '10.0.0.0/8'
		}
		milanollo,senfter: {
			$client_range    = '172.29.122.0/24'
		}
		buxtehude,glinka: {
			$client_range    = '(192.168.2.0/24 209.87.16.34/32)'
		}
		gretchaninov: {
			$client_range    = '172.29.40.0/22'
		}
		default: {
			# Better than 0.0.0.0/0 - we really ought to configure a
			# client range for them all instead of exporting to the world.
			$client_range    = '127.0.0.0/8'
		}
	}

	@ferm::rule { 'dsa-portmap':
		description => 'Allow portmap access',
		rule        => "&TCP_UDP_SERVICE_RANGE(111, $client_range)"
	}
	@ferm::rule { 'dsa-nfs':
		description => 'Allow nfsd access',
		rule        => "&TCP_UDP_SERVICE_RANGE(2049, $client_range)"
	}
	@ferm::rule { 'dsa-status':
		description => 'Allow statd access',
		rule        => "&TCP_UDP_SERVICE_RANGE(10000, $client_range)"
	}
	@ferm::rule { 'dsa-mountd':
		description => 'Allow mountd access',
		rule        => "&TCP_UDP_SERVICE_RANGE(10002, $client_range)"
	}
	@ferm::rule { 'dsa-lockd':
		description => 'Allow lockd access',
		rule        => "&TCP_UDP_SERVICE_RANGE(10003, $client_range)"
	}

	file { '/etc/default/nfs-common':
		source  => 'puppet:///modules/nfs-server/nfs-common.default',
		before  => Package['nfs-common'],
		notify  => Service['nfs-common'],
	}
	file { '/etc/default/nfs-kernel-server':
		source  => 'puppet:///modules/nfs-server/nfs-kernel-server.default',
		before  => Package['nfs-kernel-server'],
		notify  => Service['nfs-kernel-server'],
	}
	file { '/etc/modprobe.d/lockd.local':
		source => 'puppet:///modules/nfs-server/lockd.local.modprobe',
		before => Package['nfs-common'],
		notify => Service['nfs-common'],
	}
}
