# = Class: multipath
#
# Manage a multipath installation
#
# == Sample Usage:
#
#   include multipath
#
class multipath {
	case $::hostname {
		bm-bl9: {
			$conffile = 'multipath-bm-os.conf'
		}
		bm-bl1,bm-bl2,bm-bl3,bm-bl4,bm-bl5,bm-bl6,bm-bl7,bm-bl8,bm-bl13,bm-bl14: {
			$conffile = 'multipath-bm.conf'
		}
		ubc-bl8,luchesi,ubc-bl7,ubc-bl3,ubc-bl2,boito: {
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
			require     =>  Package['multipath-tools'],
		}

		file { '/etc/multipath.conf':
			content  => template("multipath/${conffile}.erb"),
			notify  => Exec['multipath reload']
		}
	}
}
