# == Class: rabbitmq::config
#
# Sets up the rabbitmq config file
#
class rabbitmq::config {

	concat { '/etc/rabbitmq/rabbitmq.config':
		require => Package['rabbitmq-server'],
		notify  => Service['rabbitmq-server'],
		owner   => root,
		group   => $::root_group,
		mode    => '0644',
	}
}
