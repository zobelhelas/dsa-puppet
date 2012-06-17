define apache2::config (
	$source=undef,
	$content=undef,
	$ensure=present
) {

	include apache2

	case $ensure {
		present: {
			if ! ($source or $content) {
				fail ( "No configuration found for ${name}" )
			}
		}
		absent:  {}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}

	if $content {
		file { "/etc/apache2/conf.d/${name}":
			ensure  => $ensure,
			content => $content,
			require => Package['apache2'],
			notify  => Service['apache2'],
		}
	} else {
		file { "/etc/apache2/conf.d/${name}":
			ensure  => $ensure,
			source  => $source,
			require => Package['apache2'],
			notify  => Service['apache2'],
		}
	}
}
