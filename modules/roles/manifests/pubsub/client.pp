# = Class: roles::pubsub::client
#
# Client config files for pubsub client
#
# == Sample Usage:
#
#   include roles::pubsub::client
#
class roles::pubsub::client {

	$rabbit_password = hkdf('/etc/puppet/secret', "mq-client-${::fqdn}")

	file { '/etc/dsa/pubsub.conf':
		content => template('roles/pubsub/pubsub.conf.erb'),
		mode    => '0440'
	}

	package { 'python-dsa-mq':
		ensure => latest
	}
}
