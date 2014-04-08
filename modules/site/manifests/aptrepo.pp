define site::aptrepo (
	$url='',
	$suite='',
	$components=[],
	$key = undef,
	$ensure = present
) {

	case $ensure {
		present: {
			if $key {
				file { "/etc/apt/trusted.gpg.d/${name}.gpg":
					source => $key,
					mode   => '0664',
				}
			}
		}
		absent:  {
			if $key {
				file { "/etc/apt/trusted.gpg.d/${name}.gpg":
					ensure => absent,
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
		notify  => Exec['apt-get update'],
	}
}
