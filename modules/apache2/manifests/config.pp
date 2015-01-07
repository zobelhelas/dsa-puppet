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

	if $::lsbmajdistrelease <= 7 {
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
	} else {
		if $content {
			file { "/etc/apache2/conf-available/${name}.conf":
				ensure  => $ensure,
				content => $content,
				require => Package['apache2'],
				notify  => Service['apache2'],
			}
		} else {
			file { "/etc/apache2/conf-available/${name}.conf":
				ensure  => $ensure,
				source  => $source,
				require => Package['apache2'],
				notify  => Service['apache2'],
			}
		}

		$link_ensure = $ensure ? {
			present => link,
			absent  => absent
		}

		file { "/etc/apache2/conf-enabled/${name}.conf":
			ensure => $link_ensure,
			target => "../conf-available/${name}.conf",
			notify => Service['apache2'],
		}
	}
}
