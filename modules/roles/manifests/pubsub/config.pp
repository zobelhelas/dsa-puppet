# = Define: roles::pubsub::config
#
# Connection stanzas for pubsub clients
#
# === Parameters
#
# [*key*]
#   The lookup key for the ini file, ie:
#   [foo] <- this
#   a=b
#
# [*topic*]
#   The topic to send or receive on
#
# [*username*]
#   Authentication username for the connection
#   Defaults to $::fqdn
#
# [*password*]
#   Authentication password for the connection
#
# [*vhost*]
#   RabbitMQ vhost to use for the connection
#   Defaults to 'dsa'
#
# [*exchange*]
#   RabbitMQ exchange to use for the connection
#   Defaults to 'dsa'
#
# [*queue*]
#   RabbitMQ queue to use for the connection
#   Only necessary on connections where client is receiving messages
#
# [*order*]
#   Ordering hint for concat
#   Defaults to '00'
#
# == Sample Usage:
#
#	roles::pubsub::config { 'testme':
#		key      => 'test',
#		exchange => dsa,
#		topic    => 'dsa.git.test',
#		vhost    => dsa,
#		username => $::fqdn,
#		password => 1234,
# 	order    => 00
#	}
#
define roles::pubsub::config (
	$key,
	$topic,
	$password,
	$vhost=dsa,
	$exchange=dsa,
	$username=$::fqdn,
	$queue=undef,
	$order=00
){
	include roles::pubsub::config::setup

	concat::fragment { "pubsub_conf_${name}":
		target => '/etc/dsa/pubsub.conf',
		source => 'puppet:///modules/roles/pubsub/pubsub.conf.erb',
		order  => $order,
	}
}
