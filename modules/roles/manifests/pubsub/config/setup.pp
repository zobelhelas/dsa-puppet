# = Class: roles::pubsub::config::setup
#
# Sets up concat fragments for pubsub config stanzas
#
# == Sample Usage:
#
#   include roles::pubsub::config::setup
#
class roles::pubsub::config::setup {
	include concat::setup

	concat { '/etc/dsa/pubsub.conf':
		owner   => root,
		group   => pubsub,
		mode    => '0440',
	}
}
