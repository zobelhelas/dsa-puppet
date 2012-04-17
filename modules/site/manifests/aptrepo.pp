define site::aptrepo ($key = undef, $keyid = undef, $content = '', $source = '', $ensure = present) {

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

	if $ensure == present {
		if ! ($source or $content) {
			fail ( "No configuration found for ${name}" )
		}
	}

	file { "/etc/apt/sources.list.d/${name}.list":
		ensure  => $ensure,
		content => $content,
		source  => $source,
		notify  => Exec['apt-get update'],
	}
}
