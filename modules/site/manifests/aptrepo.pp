define site::aptrepo (
	$url='',
	$suite='',
	$components=[],
	$key = undef,
	$keyid = undef,
	$ensure = present
) {

	case $ensure {
		present: {
			if $key {
				exec { "apt-key-update-${name}":
					command     => "apt-key add /etc/apt/trusted-keys.d/${name}.asc",
					refreshonly => true,
				}

				file { "/etc/apt/trusted-keys.d/${name}.asc":
					source => $key,
					mode   => '0664',
					notify => Exec["apt-key-update-${name}"]
				}
			}
		}
		absent:  {
			if ($keyid) and ($key) {
				file { "/etc/apt/trusted-keys.d/${name}.asc":
					ensure => absent,
					notify => Exec["apt-key-del-${keyid}"]
				}
				exec { "apt-key-del-${keyid}":
					command     => "apt-key del ${keyid}",
					refreshonly => true,
				}
			} elsif $key {
				file { "/etc/apt/trusted-keys.d/${name}.asc":
					ensure => absent,
				}
			} elsif $keyid {
				exec { "apt-key-del-${keyid}":
					command     => "apt-key del ${keyid}",
				}
			}
		}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}

	case $ensure {
		present: {
			if !($url and $suite) {
				fail ( "Need both url and suite for $name" )
			}
		}
		default: {}
	}

	file { "/etc/apt/sources.list.d/${name}.list":
			ensure  => $ensure,
			content => template('site/aptrepo.erb'),
			notify => Exec['apt-get update'],
	}
}
