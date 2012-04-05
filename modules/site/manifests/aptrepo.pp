define site::aptrepo ($key = undef, $template = undef, $config = undef, $ensure = present) {

	if $key {
		exec { "apt-key-update-${name}":
			command     => "apt-key add /etc/apt/trusted-keys.d/${name}",
			refreshonly => true,
		}

		file { "/etc/apt/trusted-keys.d/${name}":
			source => $key,
			mode   => '0664',
			notify => Exec["apt-key-update-${name}"]
		}
	}

	case $ensure {
		present: {}
		absent:  {}
		default: { err ( "Unknown ensure value: '$ensure'" ) }
	}

	if ! ($template or $config) {
		err ( "Can't find configuration for ${name}" )
	}

	if $template {
		file { "/etc/apt/sources.list.d/${name}.list":
			ensure  => $ensure,
			content => template($template),
			notify => Exec['apt-get update'],
		}
	} else {
		file { "/etc/apt/sources.list.d/${name}.list":
			ensure => $ensure,
			source => $config,
			notify => Exec['apt-get update'],
		}
	}
}
