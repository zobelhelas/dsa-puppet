# = Class: roles::mailrelay
#
# Setup for mailrelay hosts
#
# == Sample Usage:
#
#   include roles::mailrelay
#
class roles::mailrelay {
	include roles::pubsub::parameters

	$rabbit_password = $roles::pubsub::parameters::rabbit_password

	roles::pubsub::config { 'emailvdomains':
		key      => 'dsa-emailvdomains-receive',
		exchange => dsa,
		queue    => "email-${::fqdn}",
		topic    => 'dsa.email.update',
		vhost    => dsa,
		username => $::fqdn,
		password => $rabbit_password
	}
}
