class roles::pubsub {
	include roles::pubsub::params
	include roles::pubsub::entities

	$cluster_cookie  = $roles::pubsub::params::cluster_cookie

	$cc_master       = rainier
	$cc_secondary    = rapoport

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

	concat::fragment { 'rabbit_mgmt_ssl':
		target => '/etc/rabbitmq/rabbitmq.config',
		order  => 55,
		source => 'puppet:///modules/roles/pubsub/rabbitmq-mgmt.config'
	}

	@ferm::rule { 'rabbitmq':
		description => 'rabbitmq connections',
		rule        => '&SERVICE_RANGE(tcp, 5671, $HOST_DEBIAN_V4)'
	}

	@ferm::rule { 'rabbitmq-v6':
		domain      => 'ip6',
		description => 'rabbitmq connections',
		rule        => '&SERVICE_RANGE(tcp, 5671, $HOST_DEBIAN_V6)'
	}

	@ferm::rule { 'rabbitmq-adm':
		description => 'rabbitmq connections',
		rule        => '&SERVICE_RANGE(tcp, 5671, $DSA_IPS)'
	}

	@ferm::rule { 'rabbitmq-v6-adm':
		domain      => 'ip6',
		description => 'rabbitmq connections',
		rule        => '&SERVICE_RANGE(tcp, 5671, $DSA_V6_IPS)'
	}

	if $::hostname == $cc_master {
		$you  = '5.153.231.15'
		$you6 = '2001:41c8:1000:21::21:15'
	} else {
		$you  = '5.153.231.16'
		$you6 = '2001:41c8:1000:21::21:16'
	}

	@ferm::rule { 'rabbitmq_cluster':
		domain      => 'ip',
		description => 'rabbitmq cluster connections',
		rule        => "proto tcp mod state state (NEW) saddr (${you}) ACCEPT"
	}
	@ferm::rule { 'rabbitmq_cluster_v6':
		domain      => 'ip6',
		description => 'rabbitmq cluster connections',
		rule        => "proto tcp mod state state (NEW) saddr (${you6}) ACCEPT"
	}
	@ferm::rule { 'rabbitmq_mgmt':
		description => 'rabbitmq cluster connections',
		rule        => '&SERVICE_RANGE(tcp, 15672, $DSA_IPS)'
	}
	@ferm::rule { 'rabbitmq_mgmt_v6':
		domain      => '(ip6)',
		description => 'rabbitmq cluster connections',
		rule        => '&SERVICE_RANGE(tcp, 15672, $DSA_V6_IPS)'
	}
}
