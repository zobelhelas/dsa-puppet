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
	}

	rabbitmq_user { 'ftpteam':
		admin    => false,
		password => $ftp_password,
	}

	rabbitmq_user { 'buildd':
		admin    => false,
		password => $buildd_password,
	}

	rabbitmq_user { 'wbadm':
		admin    => false,
		password => $wbadm_password,
	}

	rabbitmq_user { 'mailadm':
		admin    => false,
		password => $mailadm_password,
	}

	rabbitmq_user { 'mailly':
		admin    => false,
		password => $mailly_password,
	}

	rabbitmq_user { 'muffat':
		admin    => false,
		password => $muffat_password,
	}

	rabbitmq_user { 'pet-devel':
		admin    => false,
		password => $pet_password,
	}

	$do_hosts = keys($site::localinfo)

	pubsub::autouser { $do_hosts: }

	rabbitmq_vhost { 'packages':
		ensure   => present,
	}

	rabbitmq_vhost { 'buildd':
		ensure   => present,
	}

	rabbitmq_vhost { 'dsa':
		ensure   => present,
	}

	rabbitmq_vhost { 'pet':
		ensure   => present,
	}

	rabbitmq_user_permissions { 'admin@/':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'admin@buildd':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'admin@dsa':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'admin@packages':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'admin@pet':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'ftpteam@packages':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'wbadm@packages':
		read_permission  => 'unchecked',
		write_permission => 'wbadm',
	}

	rabbitmq_user_permissions { 'buildd@buildd':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'wbadm@buildd':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'mailadm@dsa':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_user_permissions { 'pet-devel@pet':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}

	rabbitmq_policy { 'mirror-dsa@dsa':
		pattern    => '.*',
		priority   => 0,
		applyto    => 'all',
		definition => {
			'ha-mode'      => 'all',
			'ha-sync-mode' => 'automatic',
		},
	}

	rabbitmq_policy { 'mirror-buildd@buildd':
		pattern    => '.*',
		priority   => 0,
		applyto    => 'all',
		definition => {
			'ha-mode'      => 'all',
			'ha-sync-mode' => 'automatic',
		},
	}

	rabbitmq_policy { 'mirror-packages@packages':
		pattern    => '.*',
		priority   => 0,
		applyto    => 'all',
		definition => {
			'ha-mode'      => 'all',
			'ha-sync-mode' => 'automatic',
		},
	}

	rabbitmq_policy { 'mirror_pet@pet':
		pattern    => '.*',
		priority   => 0,
		applyto    => 'all',
		definition => {
			'ha-mode'      => 'all',
			'ha-sync-mode' => 'automatic',
		},
	}

	rabbitmq_plugin { 'rabbitmq_management_agent':
		ensure   => present,
	}
	rabbitmq_plugin { 'rabbitmq_tracing':
		ensure   => present,
	}
	rabbitmq_plugin { 'rabbitmq_management_visualiser':
		ensure   => present,
	}

}
