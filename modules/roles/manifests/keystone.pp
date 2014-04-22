class roles::keystone {
	ssl::service { 'openstack.bm.debian.org':
		notify => Service['apache2'],
	}
}
