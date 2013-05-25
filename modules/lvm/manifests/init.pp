class lvm {
	case $::hostname {
		dijkstra,luchesi,rossini: {
			$conffile = 'lvm-ubc-ganeti.conf'
		}
		default: {
			$conffile = ''
		}
	}

	if $conffile != '' {
		package { 'lvm2':
			ensure => installed,
		}

		file { '/etc/lvm/lvm.conf':
			source  => "puppet:///modules/lvm/$conffile",
		}
	}
}
