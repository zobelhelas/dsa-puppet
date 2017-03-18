# = Class: hardware::raid::raidmpt
#
# This class installs mpt-status and ensures the daemon is not running
#
# == Sample Usage:
#
#   include hardware::raid::raidmpt
#
class hardware::raid::raidmpt {
	if $::mptraid {
		package { 'mpt-status':
			ensure => installed
		}

		file { '/etc/default/mpt-statusd':
			content => "# This file is under puppet control\nRUN_DAEMON=no\n",
			notify  => Exec['mpt-statusd-stop'],
		}

		exec { 'mpt-statusd-stop':
			command => 'pidfile=/var/run/mpt-statusd.pid; ! [ -e "$pidfile" ] || /sbin/start-stop-daemon --oknodo --stop --signal TERM --quiet --pidfile "$pidfile"; rm -f "$pidfile";  pkill -INT  -P 1 -u 0 -f "/usr/bin/daemon /etc/init.d/mpt-statusd check_mpt"',
			refreshonly => true,
		}
	} else {
		package { 'mpt-status':
			ensure => purged,
		}

		file { '/etc/default/mpt-statusd':
			ensure => absent,
		}
	}
}
