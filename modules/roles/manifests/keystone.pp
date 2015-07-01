class roles::keystone {

	include roles::openstack::params

	$keystone_dbpass = $roles::openstack::params::keystone_dbpass
	$admin_token     = roles::openstack::params::admin_token
	$admin_pass      = roles::openstack::params::admin_pass

	class { '::keystone':
		verbose        => true,
		debug          => true,
		sql_connection => 'postgresql://keystone:$keystone_postgres_password@bmdb1.debian.org/keystone',
		catalog_type   => 'sql',
		admin_token    => $admin_token,
		enabled        => false,
	}
	class { 'keystone::roles::admin':
		email    => 'test@puppetlabs.com',
		password => $admin_pass,
	}
	class { 'keystone::endpoint':
		public_url => "https://${::fqdn}:5000/",
		admin_url  => "https://${::fqdn}:35357/",
	}

	include apache
	class { 'keystone::wsgi::apache':
		ssl      => true,
		ssl_cert => '/etc/ssl/debian/certs/openstack.bm.debian.org.crt-chained',
		ssl_key  => '/etc/ssl/private/openstack.bm.debian.org.key',

	}
}
