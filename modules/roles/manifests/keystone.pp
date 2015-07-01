class roles::keystone {

	$keystone_postgres_password = hkdf('/etc/puppet/secret', "openstack-keystone")

	class { 'keystone':
		verbose        => true,
		debug          => true,
		sql_connection => 'postgresql://keystone:$keystone_postgres_password@bmdb1.debian.org/keystone',
		catalog_type   => 'sql',
		admin_token    => 'admin_token',
		enabled        => false,
	}
	class { 'keystone::roles::admin':
		email    => 'test@puppetlabs.com',
		password => 'ChangeMe',
	}
	class { 'keystone::endpoint':
		public_url => "https://${::fqdn}:5000/",
		admin_url  => "https://${::fqdn}:35357/",
	}

	keystone_config { 'ssl/enable': value => true }

	include apache
	class { 'keystone::wsgi::apache':
		ssl => true
	}

	ssl::service { 'openstack.bm.debian.org':
		notify => Service['apache2'],
	}
}
