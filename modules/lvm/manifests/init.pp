class multipath {
	case $::hostname {
		dijkstra,luchesi,rossini: {
			$conffile = 'lvm-ubc-ganeti.conf'
		}
		default: {
			$conffile = ''
		}
	}

	if $conffile != '' {
		package { 'multipath-tools':
			ensure => installed,
		}

		file { '/etc/lvm/lvm.conf':
			source  => "puppet:///modules/lvm/$conffile",
		}
	}
}
