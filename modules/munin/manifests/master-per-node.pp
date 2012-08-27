define munin::master-per-node() {
	file { "/etc/munin/munin-conf.d/${name}.conf":
		content => template('munin/munin.conf-per-node.erb'),
	}
}
