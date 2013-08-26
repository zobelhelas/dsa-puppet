class roles::pubsub {
	include roles::pubsub::params

	$cluster_cookie = $roles::pubsub::params::cluster_cookie
	$admin_password = $roles::pubsub::params::admin_password
	$ftp_password   = $roles::pubsub::params::ftp_password
	$cc_master      = rainier
	$cc_secondary   = rapoport

	class { 'rabbitmq':
		cluster           => true,
		clustermembers    => [
			"rabbit@${cc_master}",
			"rabbit@${cc_secondary}",
		],
		clustercookie     => '8r17so6o1s124ns49sr08n0o24342160',
		delete_guest_user => true,
		master            => $cc_master,
	}

	user { 'rabbitmq':
		groups => 'ssl-cert'
	}

	concat::fragment { 'rabbit_ssl':
		target => '/etc/rabbitmq/rabbitmq.config',
		order  => 35,
		source => 'puppet:///modules/roles/pubsub/rabbitmq.config'
	}

	rabbitmq_user { 'admin':
		admin    => true,
		password => $admin_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user { 'ftpteam':
		admin    => true,
		password => $ftp_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_vhost { 'packages':
		ensure   => present,
		provider => 'rabbitmqctl',
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

	rabbitmq_user_permissions { 'admin@/':
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => Rabbitmq_user['admin']
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

	@ferm::rule { 'rabbitmq':
		description => 'rabbitmq connections',
		rule        => '&SERVICE_RANGE(tcp, 5672, $HOST_DEBIAN_V4)'
	}

	@ferm::rule { 'rabbitmq-v6':
		domain      => 'ip6',
		description => 'rabbitmq connections',
		rule        => '&SERVICE_RANGE(tcp, 5672, $HOST_DEBIAN_V6)'
	}

	if $::hostname == $cc_master {
		$you = $cc_secondary
	} else {
		$you = $cc_master
	}

	@ferm::rule { 'rabbitmq_cluster':
		domain      => '(ip ip6)',
		description => 'rabbitmq cluster connections',
		rule        => "proto tcp mod state state (NEW) saddr (${you}) ACCEPT"
	}
}
