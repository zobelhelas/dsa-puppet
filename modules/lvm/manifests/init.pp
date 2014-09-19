class lvm {
	case $::hostname {
		dijkstra,luchesi,rossini,salieri: {
			$conffile = 'lvm-ubc-ganeti.conf'
		}
		tristano,pasquini,bertali,boito: {
			$conffile = 'lvm-ubc-ganeti-p410.conf'
		}
		csail-node01,csail-node02: {
			$conffile = 'lvm-csail-nodeX-ganeti.conf'
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
