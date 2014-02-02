# = Class: roles::udldap::client
#
# Client config for udldap client
#
# == Sample Usage:
#
#   include roles::udldap::client
#
class roles::udldap::client ($ensure=present) {

	cron { 'udreplicate':
		ensure      => $ensure,
		environment => 'TERM=dumb',
		command     => '/usr/sbin/ud-replicate',
		user        => root,
		hour        => '*',
		minute      => [10,25,40,55],
	}
}
