define rsync::site (
	$bind='',
	$source='',
	$content='',
	$fname="/etc/rsyncd-${title}.conf",
	$max_clients=200,
	$ensure=present
){

	include rsync

	case $ensure {
		present,absent: {}
		default: { fail ( "Invald ensure `${ensure}' for ${name}" ) }
	}

	if ($source and $content) {
		fail ( "Can't define both source and content for ${name}" )
	}

	if $source {
		file { $fname:
			ensure => $ensure,
			source => $source
		}
	} elsif $content {
		file { $fname:
			ensure  => $ensure,
			content => $content,
		}
	} else {
		fail ( "Can't find config for ${name}" )
	}

	xinetd::service { "rsync-${name}":
		bind        => $bind,
		id          => "${name}-rsync",
		server      => '/usr/sbin/rsyncd',
		port        => 'rsync',
		server_args => $fname,
		ferm        => false,
		instances   => $max_clients,
		require     => File[$fname]
	}

	Service['rsync']->Service['xinetd']
}
