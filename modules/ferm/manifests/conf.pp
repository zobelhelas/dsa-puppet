define ferm::conf ($content=undef, $source=undef, $ensure=present) {

	include ferm

	case $ensure {
		present,absent: {}
		default: { fail ( "Invald ensure `${ensure}' for ${name}" ) }
	}

	if ($source and $content) {
		fail ( "Can't define both source and content for ${name}" )
	}

	$fname = "/etc/ferm/conf.d/${name}.conf"

	if $source {
		file { $fname:
			ensure => $ensure,
			source => $source,
			notify => Service['ferm']
		}
	} elsif $content {
		file { $fname:
			ensure  => $ensure,
			content => $content,
			notify => Service['ferm']
		}
	}
}
