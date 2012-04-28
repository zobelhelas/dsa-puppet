define vsftpd::site (
	$source='',
	$content='',
	$bind='',
	$ensure=present
){

	include vsftpd::nolisten

	if ($source and $content) {
		fail ( "Can't have both source and content for $name" )
	}

	case $ensure {
		present,absent: {}
		default: { fail ( "Invald ensure `$ensure' for $name" ) }
	}

	$fname = "/etc/vsftpd-${name}.conf"

	$noop = $::hostname ? {
		gluck    => false,
		lobos    => false,
		saens    => false,
		santoro  => false,
		schein   => false,
		steffani => false,
		villa    => false,
		wieck    => false,
		default  => true
	}

	if $source {
		file { $fname:
			ensure => $ensure,
			noop   => $noop,
			source => $source,
		}
	} elsif $content {
		file { $fname:
			ensure  => $ensure,
			noop    => $noop,
			content => $content,
		}
	} else {
		fail ( "Need one of source or content for $name" )
	}

	# We don't need a firewall rule because it's added in vsftp.pp
	xinetd::service { "vsftpd-${name}":
		bind        => $bind,
		id          => "${name}-ftp",
		server      => '/usr/sbin/vsftpd',
		port        => 'ftp',
		server_args => $fname,
		ferm        => false,
		require     => File[$fname]
	}

}
