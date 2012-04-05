define apache2::site (
	$config = undef,
	$template = false,
	$ensure = present,
	$site = undef
) {

	include apache2

	if $ensure == present {
		if ! ($config or $template) {
			fail ( "No configuration found for ${name}" )
		}
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

	case $template {
		false: {
			file { $target:
				ensure  => $ensure,
				source  => $config,
				require => Package['apache2'],
				notify  => Service['apache2'],
			}
		}
		default: {
			file { $target:
				ensure  => $ensure,
				content => template($template),
				require => Package['apache2'],
				notify  => Service['apache2'],
			}
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
