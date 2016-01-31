define xinetd::service (
	$id,
	$server,
	$service,
	$port=$service,
	$bind='',
	$type='',
	$socket_type=stream,
	$protocol=tcp,
	$flags='',
	$wait=no,
	$user=root,
	$group='',
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
			description => "Allow traffic to ${service}",
			rule        => "&SERVICE(${protocol}, ${port})"
		}
	}

	file { "/etc/xinetd.d/${name}":
		ensure  => $ensure,
		content => template('xinetd/service.erb'),
		notify  => Service['xinetd'],
		require => Package['xinetd'],
	}
}
