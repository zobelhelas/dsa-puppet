define xinetd::service (
	$id,
	$server,
	$service,
	$port='',
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
	case $ensure {
		present,file: {
			include xinetd
			file { "/etc/xinetd.d/${name}":
				ensure  => $ensure,
				content => template('xinetd/service.erb'),
				notify  => Service['xinetd'],
				require => Package['xinetd'],
			}
		}
		absent: {
			file { "/etc/xinetd.d/${name}":
				ensure  => $ensure,
			}
		}
		default: { fail("Invalid ensure for '$name'") }
	}

	if $ferm {
		$fermport = $port ? {
			"" => $service,
			default => $port
		}

		@ferm::rule { "dsa-xinetd-${name}":
			description => "Allow traffic to ${service}",
			rule        => "&SERVICE(${protocol}, ${fermport})"
		}
	}
}
