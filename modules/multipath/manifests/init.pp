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
		bm-bl1,bm-bl2,bm-bl3,bm-bl4,bm-bl5,bm-bl6,bm-bl7,bm-bl8,bm-bl9,bm-bl10,bm-bl11,bm-bl12: {
			$conffile = 'multipath-bm.conf'
		}
		ubc-bl8,ubc-bl4,ubc-bl7,ubc-bl3,ubc-bl2,ubc-bl6: {
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
