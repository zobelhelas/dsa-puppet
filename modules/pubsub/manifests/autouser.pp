# == Define: pubsub::autouser
#
# Create a user in rabbitmq automatically for debian.org hosts
# Should automatically create a password
#
# === Parameters
#
# === Examples
#
#  pubsub::autouser { 'master.debian.org': }
#
define pubsub::autouser () {

	$pubsub_password = hkdf('/etc/puppet/secret', "mq-client-${name}")

	rabbitmq_user { $name:
		admin    => false,
		password => $pubsub_password,
	}

	rabbitmq_user_permissions { "${name}@dsa":
		configure_permission => '.*',
		read_permission      => '.*',
		write_permission     => '.*',
	}
}

