define munin::master_per_node($ipaddress, $munin_async) {
	$client_fqdn               = $name
	$client_ipaddress          = $ipaddress
	$client_munin_async        = $munin_async

	file { "/etc/munin/munin-conf.d/${name}.conf":
		content => template('munin/munin.conf_per_node.erb'),
	}
}
