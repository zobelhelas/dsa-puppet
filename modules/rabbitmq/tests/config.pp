class rabbitmq::packages {
	package { 'rabbitmq-server': }
	service { 'rabbitmq-server': }
}
class concat::setup {}

include rabbitmq::config
