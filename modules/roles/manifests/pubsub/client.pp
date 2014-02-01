# = Class: roles::pubsub::client
#
# Client config files for pubsub client
#
# == Sample Usage:
#
#   include roles::pubsub::client
#
class roles::pubsub::client {

	include roles::pubsub::parameters

	$rabbit_password = $roles::pubsub::parameters::rabbit_password

	package { [
		'python-dsa-mq',
		'python-kombu'
	]:
		ensure => installed,
		tag    => extra_repo,
	}

	roles::pubsub::config { 'homedirs':
		key      => 'dsa-homedirs',
		exchange => dsa,
		topic    => 'dsa.git.homedirs',
		vhost    => dsa,
		username => $::fqdn,
		password => $rabbit_password
	}

	roles::pubsub::config { 'replicate':
		key      => 'dsa-udreplicate',
		exchange => dsa,
		queue    => "ud-${::fqdn}",
		topic    => 'dsa.ud.replicate',
		vhost    => dsa,
		username => $::fqdn,
		password => $rabbit_password
	}
}
