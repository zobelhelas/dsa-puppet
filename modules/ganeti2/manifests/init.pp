# = Class: ganeti2
#
# Standard ganeti2 config debian.org hosts
#
# == Sample Usage:
#
#   include ganeti2
#
class ganeti2 {

	include ganeti2::params
	include ganeti2::firewall

	$drbd = $ganeti2::params::drbd

	package { 'ganeti':
		ensure => installed
	}

	if $drbd {
		package { 'drbd8-utils':
			ensure => installed
		}
	}

	site::linux_module { 'tun': }
}
