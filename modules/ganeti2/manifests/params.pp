class ganeti2::params {
	
	$cluster = hiera('cluster')
	case $luster {
		'ganeti-osuosl.debian.org': {
			$ganeti_hosts = ['140.211.166.20/32']
			$ganeti_priv  = ['140.211.166.20/32']
			$drbd         = false
		}
		'ganeti2.debian.org': {
			$ganeti_hosts = ['206.12.19.213/32', '206.12.19.217/32', '206.12.19.212/32', '206.12.19.216/32']
			$ganeti_priv  = ['192.168.2.213/32', '192.168.2.217/32', '192.168.2.212/32', '192.168.2.216/32']
			$drbd         = true
		}
		'ganeti3.debian.org': {
			$ganeti_hosts = ['82.195.75.103/32', '82.195.75.109/32']
			$ganeti_priv  = ['192.168.75.103/32', '192.168.75.109/32']
			$drbd         = true
		}
		default: {
			$ganeti_hosts = []
			$ganeti_priv  = []
			$drbd         = false
		}
	}
}
