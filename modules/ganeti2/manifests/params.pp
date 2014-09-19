# = Class: ganeti2::params
#
# Parameters for ganeti clusters
#
# == Sample Usage:
#
#   include ganeti2::params
#
class ganeti2::params {
	case $::cluster {
		'ganeti-osuosl.debian.org': {
			$ganeti_hosts = ['140.211.166.20/32']
			$ganeti_priv  = ['140.211.166.20/32']
			$drbd         = false
		}
		'ganeti2.debian.org': {
			$ganeti_hosts = ['206.12.19.213/32', '206.12.19.217/32', '206.12.19.212/32', '206.12.19.216/32', '206.12.19.19/32', '206.12.19.20/32', '206.12.19.218/32', '206.12.19.214/32']
			$ganeti_priv  = ['192.168.2.213/32', '192.168.2.217/32', '192.168.2.212/32', '192.168.2.216/32', '192.168.2.19/32', '192.168.2.20/32', '192.168.2.218/32', '192.168.2.214/32']
			$drbd         = true
		}
		'ganeti3.debian.org': {
			$ganeti_hosts = ['82.195.75.103/32', '82.195.75.109/32']
			$ganeti_priv  = ['192.168.75.103/32', '192.168.75.109/32']
			$drbd         = true
		}
		'ganeti.bm.debian.org': {
			$ganeti_hosts = ['5.153.231.240/28']
			$ganeti_priv  = ['172.29.120.0/24']
			$drbd         = false
		}
		'ganeti.csail.debian.org': {
			$ganeti_hosts = ['128.31.0.16/32', '128.31.0.46/32']
			$ganeti_priv  = ['172.29.178.0/24']
			$drbd         = true
		}
		default: {
			$ganeti_hosts = []
			$ganeti_priv  = []
			$drbd         = false
		}
	}
}
