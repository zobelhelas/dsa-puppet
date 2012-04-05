define apache2::config($config = undef, $template = undef, $ensure = present) {

	include apache2

	case $ensure {
		present: {
			if ! ($config or $template) {
				fail ( "No configuration found for ${name}" )
			}
		}
		absent:  {}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}

	if $template {
		file { "/etc/apache2/conf.d/${name}":
			ensure  => $ensure,
			content => template($template),
			require => Package['apache2'],
			notify  => Service['apache2'],
		}
	} else {
		file { "/etc/apache2/conf.d/${name}":
			ensure  => $ensure,
			source  => $config,
			require => Package['apache2'],
			notify  => Service['apache2'],
		}
	}
}
