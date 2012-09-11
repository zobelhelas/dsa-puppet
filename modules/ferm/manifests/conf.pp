define ferm::conf ($content=undef, $source=undef, $ensure=present) {

	case $ensure {
		present,absent: {}
		default: { fail ( "Invald ensure `${ensure}' for ${name}" ) }
	}

	if ($source and $content) {
		fail ( "Can't define both source and content for ${name}" )
	}

	if $source {
		file { "/etc/ferm/conf.d/${name}":
			ensure => $ensure,
			source => $source
		}
	} elsif $content {
		file { "/etc/ferm/conf.d/${name}":
			ensure  => $ensure,
			content => $content,
		}
	}
}
