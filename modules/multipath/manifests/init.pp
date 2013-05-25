class multipath {
	case $::hostname {
		bm-bl1,bm-bl2,bm-bl3,bm-bl4,bm-bl5,bm-bl6,bm-bl7,bm-bl8,bm-bl9,bm-bl10,bm-bl11,bm-bl12,bm-bl13,bm-bl14: {
			$conffile = 'multipath-bm.conf'
		}
		dijkstra,luchesi,rossini,salieri: {
			$conffile = 'multipath-ubc-ganeti.conf'
		}
		default: {
			$conffile = ''
		}
	}

	if $conffile != '' {
		package { 'multipath-tools':
			ensure => installed,
		}
		exec { 'multipath reload':
			path        => '/usr/bin:/usr/sbin:/bin:/sbin',
			command     => 'service multipath-tools reload',
			refreshonly => true,
			require =>  Package['multipath-tools'],
		}

		file { '/etc/multipath.conf':
			source  => "puppet:///modules/multipath/$conffile",
			notify  => Exec['multipath reload']
		}
	}
}
