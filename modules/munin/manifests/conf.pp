define munin::conf (
	$ensure=present,
	$content=false,
	$source=false
) {

	include munin

	case $ensure {
		present: {
			if ! ($source or $content) {
				fail ( "No configuration found for ${name}" )
			}
		}
		absent:  {}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}

	if $source {
		file { "/etc/munin/plugin-conf.d/${name}":
			ensure  => $ensure,
			source  => $source,
			require => Package['munin-node'],
			notify  => Service['munin-node'],
		}
	} elsif $content {
		file { "/etc/munin/plugin-conf.d/${name}":
			ensure  => $ensure,
			content => $content,
			require => Package['munin-node'],
			notify  => Service['munin-node'],
		}
	}
}
