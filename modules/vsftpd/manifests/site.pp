define vsftpd::site (
	$source='',
	$content='',
	$bind='',
	$logfile="/var/log/ftp/vsftpd-${name}.debian.org.log",
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

	if $source {
		file { $fname:
			ensure => $ensure,
			source => $source,
		}
	} elsif $content {
		file { $fname:
			ensure  => $ensure,
			content => $content,
		}
	} else {
		fail ( "Need one of source or content for $name" )
	}

	file { "/etc/logrotate.d/vsftpd-${name}":
		ensure  => $ensure,
		content => template('vsftpd/logrotate.erb')
	}

	# We don't need a firewall rule because it's added in vsftp.pp
	xinetd::service { "vsftpd-${name}":
		bind        => $bind,
		id          => "${name}-ftp",
		server      => '/usr/sbin/vsftpd',
		port        => 'ftp',
		server_args => $fname,
		ferm        => false,
		instances   => 200,
		require     => File[$fname]
	}

}
