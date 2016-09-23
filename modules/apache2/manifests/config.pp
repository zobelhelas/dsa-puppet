define apache2::config (
	$source=undef,
	$content=undef,
	$nocontentok=undef,
	$ensure=present
) {

	include apache2

	case $ensure {
		present: {
			if ! ($source or $content or $nocontentok) {
				fail ( "No configuration found for ${name}" )
			}

			if $content {
				file { "/etc/apache2/conf-available/${name}.conf":
					ensure  => $ensure,
					content => $content,
					require => Package['apache2'],
					notify  => Exec['service apache2 reload'],
				}
			} elsif $source {
				file { "/etc/apache2/conf-available/${name}.conf":
					ensure  => $ensure,
					source  => $source,
					require => Package['apache2'],
					notify  => Exec['service apache2 reload'],
				}
			}
		}
		absent:  {
			file { "/etc/apache2/conf-available/${name}.conf":
				ensure  => $ensure,
				require => Package['apache2'],
				notify  => Exec['service apache2 reload'],
			}
		}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}
	$link_ensure = $ensure ? {
		present => link,
		absent  => absent
	}

	file { "/etc/apache2/conf-enabled/${name}.conf":
		ensure => $link_ensure,
		target => "../conf-available/${name}.conf",
		notify  => Exec['service apache2 reload'],
	}
}
