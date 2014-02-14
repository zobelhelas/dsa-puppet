# == Define: rabbitmq::autouser
#
# Create a user in rabbitmq automatically for debian.org hosts
# Should automatically create a password
#
# === Parameters
#
# === Examples
#
#  rabbitmq::autouser { 'master.debian.org': }
#
define rabbitmq::autouser () {

	$rabbit_password = hkdf('/etc/puppet/secret', "mq-client-${name}")

	rabbitmq_user { $name:
		admin    => false,
		password => $rabbit_password,
		provider => 'rabbitmqctl',
	}

	rabbitmq_user_permissions { "${name}@dsa":
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
		provider             => 'rabbitmqctl',
		require              => [
			Rabbitmq_user[$name],
			Rabbitmq_vhost['dsa']
		]
	}
}
