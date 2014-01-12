# = Class: roles::pubsub::entities
#
# MQ users, vhosts, policies, and permissions for pubsub hosts
#
# == Sample Usage:
#
#   include roles::pubsub::entities
#
class roles::pubsub::entities {
	include roles::pubsub::params

	$admin_password   = $roles::pubsub::params::admin_password
	$ftp_password     = $roles::pubsub::params::ftp_password
	$buildd_password  = $roles::pubsub::params::buildd_password
	$wbadm_password   = $roles::pubsub::params::wbadm_password
	$mailadm_password = $roles::pubsub::params::mailadm_password
	$mailly_password  = $roles::pubsub::params::mailly_password
	$muffat_password  = $roles::pubsub::params::muffat_password
	$pet_password     = $roles::pubsub::params::pet_password

	rabbitmq_user { 'admin':
		admin    => true,
		password => $admin_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user { 'ftpteam':
		admin    => false,
		password => $ftp_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user { 'buildd':
		admin    => false,
		password => $buildd_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user { 'wbadm':
		admin    => false,
		password => $wbadm_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user { 'mailadm':
		admin    => false,
		password => $mailadm_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user { 'mailly':
		admin    => false,
		password => $mailly_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user { 'muffat':
		admin    => false,
		password => $muffat_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user { 'pet-devel':
		admin    => false,
		password => $pet_password,
		provider => 'rabbitmqctl',
	}

	$do_hosts = keys($site::localinfo)

	rabbitmq::autouser { $do_hosts: }

	rabbitmq_vhost { 'packages':
		ensure   => present,
		provider => 'rabbitmqctl',
	}

	rabbitmq_vhost { 'buildd':
		ensure   => present,
		provider => 'rabbitmqctl',
	}

	rabbitmq_vhost { 'dsa':
		ensure   => present,
		provider => 'rabbitmqctl',
	}

	rabbitmq_vhost { 'pet':
		ensure   => present,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user_permissions { 'admin@/':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => Rabbitmq_user['admin']
	}

	rabbitmq_user_permissions { 'admin@buildd':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['admin'],
			Rabbitmq_vhost['buildd']
		]
	}

	rabbitmq_user_permissions { 'admin@dsa':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['admin'],
			Rabbitmq_vhost['dsa']
		]
	}

	rabbitmq_user_permissions { 'admin@packages':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['admin'],
			Rabbitmq_vhost['packages']
		]
	}

	rabbitmq_user_permissions { 'admin@pet':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['admin'],
			Rabbitmq_vhost['pet']
		]
	}

	rabbitmq_user_permissions { 'ftpteam@packages':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['ftpteam'],
			Rabbitmq_vhost['packages']
		]
	}

	rabbitmq_user_permissions { 'wbadm@packages':
		read_permission      => 'unchecked',
		write_permission     => 'wbadm',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['wbadm'],
			Rabbitmq_vhost['packages']
		]
	}

	rabbitmq_user_permissions { 'buildd@buildd':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['buildd'],
			Rabbitmq_vhost['buildd']
		]
	}

	rabbitmq_user_permissions { 'wbadm@buildd':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['wbadm'],
			Rabbitmq_vhost['buildd']
		]
	}

	rabbitmq_user_permissions { 'mailadm@dsa':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['mailadm'],
			Rabbitmq_vhost['dsa']
		]
	}

	rabbitmq_user_permissions { 'pet-devel@pet':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user['pet-devel'],
			Rabbitmq_vhost['pet']
		]
	}

	rabbitmq_policy { 'mirror-dsa':
		vhost   => 'dsa',
		match   => '.*',
		policy  => '{"ha-mode":"all"}',
		require => Rabbitmq_vhost['dsa']
	}

	rabbitmq_policy { 'mirror-buildd':
		vhost   => 'buildd',
		match   => '.*',
		policy  => '{"ha-mode":"all"}',
		require => Rabbitmq_vhost['buildd']
	}

	rabbitmq_policy { 'mirror-packages':
		vhost   => 'packages',
		match   => '.*',
		policy  => '{"ha-mode":"all"}',
		require => Rabbitmq_vhost['packages']
	}

	rabbitmq_policy { 'mirror_pet':
		vhost   => 'pet',
		match   => '.*',
		policy  => '{"ha-mode":"all"}',
		require => Rabbitmq_vhost['pet']
	}

	rabbitmq_plugin { 'rabbitmq_management':
		ensure   => present,
		provider => 'rabbitmqplugins',
		require  => Package['rabbitmq-server'],
		notify   => Service['rabbitmq-server']
	}
	rabbitmq_plugin { 'rabbitmq_management_agent':
		ensure   => present,
		provider => 'rabbitmqplugins',
		require  => Package['rabbitmq-server'],
		notify   => Service['rabbitmq-server']
	}
	rabbitmq_plugin { 'rabbitmq_tracing':
		ensure   => present,
		provider => 'rabbitmqplugins',
		require  => Package['rabbitmq-server'],
		notify   => Service['rabbitmq-server']
	}
	rabbitmq_plugin { 'rabbitmq_management_visualiser':
		ensure   => present,
		provider => 'rabbitmqplugins',
		require  => Package['rabbitmq-server'],
		notify   => Service['rabbitmq-server']
	}

}
