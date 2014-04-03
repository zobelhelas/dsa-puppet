# = Class: roles::git_master
#
# Setup for git/git2.debian.org master host
#
# == Sample Usage:
#
#   include roles::git_master
#
class roles::git_master {

	include roles::pubsub::parameters

	$rabbit_password = $roles::pubsub::parameters::rabbit_password

	roles::pubsub::config { 'emailvdomains':
		key      => 'dsa-emailvdomains',
		exchange => dsa,
		topic    => 'dsa.email.update',
		vhost    => dsa,
		username => $::fqdn,
		password => $rabbit_password
	}
}
