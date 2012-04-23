# = Class: hosts
#
# This class fixes up broken /etc/hosts files
#
# == Sample Usage:
#
#   include hosts
#
class hosts {
	file { '/etc/hosts':
		content => template('hosts/etc-hosts.erb')
	}
}
