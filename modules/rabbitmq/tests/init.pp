class site::users::system::rabbitmq {}
class rabbitmq::config {}
class rabbitmq::packages {
	package { 'rabbitmq-server': }
}
include rabbitmq
