define apache2::module ($ensure = present) {
	case $ensure {
		present: {
			exec { "/usr/sbin/a2enmod ${name}":
				creates => "/etc/apache2/mods-enabled/${name}.load",
				notify  => Service['apache2']
			}
		}
		absent: {
			exec { "/usr/sbin/a2dismod ${name}":
				onlyif => "test -L /etc/apache2/mods-enabled/${name}.load",
				notify => Service['apache2']
			}
		}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}
}
