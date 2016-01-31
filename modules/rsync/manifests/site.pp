define rsync::site (
	$bind='',
	$bind6='',
	$source='',
	$content='',
	$fname='',
	$max_clients=200,
	$ensure=present
){

	include rsync

	if ! $fname {
		$fname_real = "/etc/rsyncd-${name}.conf"
	} else {
		$fname_real = $fname
	}
	case $ensure {
		present,absent: {}
		default: { fail ( "Invald ensure `${ensure}' for ${name}" ) }
	}

	if ($source and $content) {
		fail ( "Can't define both source and content for ${name}" )
	}

	if $source {
		file { $fname_real:
			ensure => $ensure,
			source => $source
		}
	} elsif $content {
		file { $fname_real:
			ensure  => $ensure,
			content => $content,
		}
	} else {
		fail ( "Can't find config for ${name}" )
	}

	xinetd::service { "rsync-${name}":
		bind        => $bind,
		id          => "${name}-rsync",
		server      => '/usr/bin/rsync',
		port        => 'rsync',
		server_args => "--daemon --config=${fname_real}",
		ferm        => false,
		instances   => $max_clients,
		require     => File[$fname_real]
	}

	if $bind6 != '' {
		if $bind == '' {
			fail("Cannot listen on * and a specific ipv6 address")
		}
		xinetd::service { "rsync-${name}6":
			bind        => $bind6,
			id          => "${name}-rsync6",
			server      => '/usr/bin/rsync',
			service     => 'rsync',
			server_args => "--daemon --config=${fname_real}",
			ferm        => false,
			instances   => $max_clients,
			require     => File[$fname_real]
		}
	}

	Service['rsync']->Service['xinetd']
}
