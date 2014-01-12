# = Class: roles::pubsub::client
#
# Client config files for pubsub client
#
# == Sample Usage:
#
#   include roles::pubsub::client
#
class roles::pubsub::client {

	$rabbit_password = hkdf('/etc/puppet/secret', "mq-client-${name}")

	file { '/etc/dsa/pubsub.conf':
		content => template('roles/pubsub/pubsub.conf.erb')
	}
}
