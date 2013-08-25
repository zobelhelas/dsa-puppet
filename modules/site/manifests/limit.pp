# == Define: site::limit
#
# Apply a ulimit for a particular user on this system. Most commonly used for
# increasing the number of open files that are allowed on the system.
#
# === Parameters
#
# [*limit_user*]
#   The user account to apply the limit to. Can also be a group, see
#   http://linux.die.net/man/5/limits.conf or the manual page for limits.conf
#   for details.
#
# [*limit_value*]
#   The number that this limit should be increased to.
#
# [*limit_type*]
#   Whether the limit is hard, soft, or '-'.
#
# [*limit_item*]
#   The item to apply the limit to. See http://linux.die.net/man/5/limits.conf
#   or the manual page for limits.conf for something accurate for a specific
#   OS. This defaults to nofile as this is the most commonly changed limit.
#
# === Examples
#
#  site::limit { 'a_jetty_app':
#    limit_user => jetty,
#    #limit_type => nofile # this is the default so commented out
#    limit_type  => hard
#    limit_value => 8192
#  }
#
define site::limit (
	$limit_user,
	$limit_value,
	$limit_type = '-',
	$limit_item = 'nofile',
	$ensure = 'present'
) {

	case $limit_item {
		'as': {}
		'chroot': {}
		'core': {}
		'cpu': {}
		'data': {}
		'fsize': {}
		'locks': {}
		'maxlogins': {}
		'maxsyslogins': {}
		'memlock': {}
		'msgqueue': {}
		'nice': {}
		'nofile': {}
		'nproc': {}
		'priority': {}
		'rss': {}
		'rtprio': {}
		'sigpending': {}
		'stack': {}
		default: {
			fail("${limit_item} is not a valid ulimit item")
		}
	}

	case $limit_type {
		'-': {}
		'soft': {}
		'hard': {}
		default: {
			fail("${limit_item} is not a valid ulimit type")
		}
	}

	file { "/etc/security/limits.d/${name}.conf":
		ensure  => $ensure,
		content => template('site/limits.conf.erb'),
		owner   => root,
		group   => root,
		mode    => '0444'
	}

}
