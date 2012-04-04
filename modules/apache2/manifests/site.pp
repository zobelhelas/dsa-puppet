define apache2::site (
	$config = undef,
	$template = undef,
	$ensure = present,
	$site = undef
) {

	include apache2

	if ! ($config or $template) {
		err ( "No configuration found for ${name}" )
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
		default => err ( "Unknown ensure value: '$ensure'" ),
	}

	if $template {
		file { $target:
			ensure  => $ensure,
			content => template($template),
			require => Package['apache2'],
			notify  => Service['apache2'],
		}
	} else {
		file { $target:
			ensure  => $ensure,
			source  => $config,
			require => Package['apache2'],
			notify  => Service['apache2'],
		}
	}

	file { "/etc/apache2/sites-enabled/${name}":
		ensure => $link_target,
		notify => Service['apache2'],
	}
}
