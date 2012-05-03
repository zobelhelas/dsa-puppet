define apache2::site (
	$source=undef,
	$content=false,
	$ensure=present,
	$site=undef
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

	if $site {
		$base = $site
	} else {
		$base = $name
	}

	$target = "/etc/apache2/sites-available/${base}"

	$link_target = $ensure ? {
		present => $target,
		absent  => absent,
		default => fail ( "Unknown ensure value: '$ensure'" ),
	}

	if $content {
		file { $target:
			ensure  => $ensure,
			content => $content,
			require => Package['apache2'],
			notify  => Service['apache2'],
		}
	} else {
		file { $target:
			ensure  => $ensure,
			source  => $source,
			require => Package['apache2'],
			notify  => Service['apache2'],
		}
	}

	if $ensure == present {
		file { "/etc/apache2/sites-enabled/${name}":
			ensure => link,
			target => $link_target,
			notify => Service['apache2'],
		}
	} else {
		file { "/etc/apache2/sites-enabled/${name}":
			ensure => absent,
			notify => Service['apache2'],
		}
	}
}
