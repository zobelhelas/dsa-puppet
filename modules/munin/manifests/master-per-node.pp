define munin::master-per-node($ipaddress, $munin_async) {
	$client_fqdn               = $name
	$client_ipaddress          = $ipaddress
	$client_munin_async        = $munin_async

	file { "/etc/munin/munin-conf.d/${name}.conf":
		content => template('munin/munin.conf-per-node.erb'),
	}
}
