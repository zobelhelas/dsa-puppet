class vsftpd::site (
	$source='',
	$content='',
	$bind=$::ipaddress,
	$ensure=present
){

	include vsftpd
	include vsftpd::nolisten

	if ($source and $content) {
		fail ( "Can't have both source and content for $name" )
	}

	case $ensure {
		present,absent: {}
		default: { fail ( "Invald ensure `$ensure' for $name" ) }
	}

	$fname = "/etc/vsftpd-${name}.conf"

	if $source {
		file { $fname:
			ensure => $ensure,
			noop   => true,
			source => $source,
		}
	} elsif $content {
		file { $fname:
			ensure  => $ensure,
			noop    => true,
			content => $content,
		}
	} else {
		fail ( "Need one of source or content for $name" )
	}

	# We don't need a firewall rule because it's added in vsftp.pp
	xinetd::service { "vsftpd-${name}":
		bind        => $bind,
		id          => $name,
		server      => '/usr/sbin/vsftpd',
		port        => 'ftp',
		server_args => $fname,
		ferm        => false,
	}

}
