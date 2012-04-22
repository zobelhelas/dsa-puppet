class vsftpd::site (
	$source='',
	$content='',
	$ensure=present
){

	include vsftpd

	if ($source and $content) {
		fail ( "Can't have both source and content for $name" )
	}

	case $ensure {
		present,absent: {}
		default: { fail ( "Invald ensure `$ensure' for $name" ) }
	}

	if $source {
		file { '/etc/vsftpd.conf':
			ensure => $ensure,
			source => $source,
			notify => Service['vsftpd']
		}
	} elsif $content {
		file { '/etc/vsftpd.conf':
			ensure  => $ensure,
			content => $content,
			notify  => Service['vsftpd']
		}
	} else {
		fail ( "Need one of source or content for $name" )
	}

}
