define apache2::site (
	$source=undef,
	$content=undef,
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
		absent  => absent
	}

	if $content {
		file { $target:
			ensure  => $ensure,
			content => $content,
			require => Package['apache2'],
			notify  => Exec['service apache2 reload'],
		}
	} else {
		file { $target:
			ensure  => $ensure,
			source  => $source,
			require => Package['apache2'],
			notify  => Exec['service apache2 reload'],
		}
	}

	if $::lsbmajdistrelease <= '7' {
		$symlink = "/etc/apache2/sites-enabled/${name}"
	} else {
		$symlink = "/etc/apache2/sites-enabled/${name}.conf"

		file { "/etc/apache2/sites-enabled/${name}":
			ensure => absent,
			notify  => Exec['service apache2 reload'],
		}
	}

	if $ensure == present {
		file { $symlink:
			ensure => link,
			target => $link_target,
			notify  => Exec['service apache2 reload'],
		}
	} else {
		file { $symlink:
			ensure => absent,
			notify  => Exec['service apache2 reload'],
		}
	}
}
