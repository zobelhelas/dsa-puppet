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
		default: { fail("Invalid ensure for '$title'") }
	}

	if $ferm {
		@ferm::rule { "dsa-xinetd-${title}":
			description => "Allow traffic to ${port}",
			rule        => "&SERVICE(${protocol}, ${port})"
		}
	}

	file { "/etc/xinetd.d/${title}.conf":
		ensure  => $ensure,
		noop    => true,
		content => template('xinetd/service.erb'),
		notify  => Service['xinetd'],
		require => Package['xinetd'],
	}
}
