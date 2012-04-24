define xinetd::service (
	$bind,
	$id,
	$server,
	$port,
	$socket_type=stream,
	$protocol=tcp,
	$flags=IPv6,
	$wait=no,
	$user=root,
	$server_args='',
	$nice=10,
	$instances=100,
	$per_source=3,
	$cps='0 0',
	$ensure=present,
	$ferm=true
) {
	include xinetd

	case $ensure {
		present,absent,file: {}
		default: { fail("Invalid ensure for '$name'") }
	}

	if $ferm {
		@ferm::rule { "dsa-xinetd-${name}":
			description => "Allow traffic to ${port}",
			rule        => "&SERVICE(${protocol}, ${port})"
		}
	}

	file { "/etc/xinetd.d/${name}.conf":
		ensure  => $ensure,
		content => template('xinetd/service.erb'),
		notify  => Service['xinetd'],
		require => Package['xinetd'],
	}
}
