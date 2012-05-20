define munin::conf (
	$ensure=present,
	$content='',
	$source=''
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

	file { "/etc/munin/plugin-conf.d/${name}":
		ensure  => $ensure,
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}
}
