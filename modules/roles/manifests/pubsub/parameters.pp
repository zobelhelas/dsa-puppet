# = Class: roles::pubsub::parameters
#
# Params for pubsub client
#
# == Sample Usage:
#
#   include roles::pubsub::parameters
#
class roles::pubsub::parameters {

	$rabbit_password = hkdf('/etc/puppet/secret', "mq-client-${::fqdn}")
}
