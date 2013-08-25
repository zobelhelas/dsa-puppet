class site::aptrepo::rabbitmq {}
class site::yumrepo::rabbitmq {}
class site::users::system::rabbitmq {
	user { 'rabbitmq': }
}
include rabbitmq::packages

