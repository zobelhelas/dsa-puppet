# == Class: rabbitmq::packages
#
# Installs all the rabbitmq software
#
class rabbitmq::packages {
		$ensure = installed

	package { 'rabbitmq-server':
		ensure  => $ensure,
		require => User['rabbitmq']
	}
}
