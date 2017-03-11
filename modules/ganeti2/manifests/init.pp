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

	site::linux_module { 'tun': }

	file { '/etc/cron.hourly/puppet-cleanup-watcher-pause-file':
		source => 'puppet:///modules/ganeti2/cleanup-watcher-pause-file',
		mode    => '0555',
	}
}
