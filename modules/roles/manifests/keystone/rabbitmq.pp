class roles::keystone::rabbitmq {

	include roles::openstack::params

	$rabbit_pass     = $roles::openstack::params::rabbit_pass

	rabbitmq_vhost { 'keystone':
		ensure   => present,
	}

	rabbitmq_user { 'openstack':
		admin    => false,
		password => $rabbit_pass,
	}

	rabbitmq_user_permissions { 'openstack@keystone':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}
}
