define site::alternative ($linkto, $ensure = present) {
	case $ensure {
		present: {
			if $::lsbdistcodename == 'lenny' {
				exec { "/usr/sbin/update-alternatives --set ${name} ${linkto}":
					unless => "[ $(basename $(readlink -f /etc/alternatives/${name})) = ${linkto} ]",
				}
			} else {
				exec { "/usr/sbin/update-alternatives --set ${name} ${linkto}":
					unless => "[ $(update-alternatives --query ${name} | grep ^Value | awk '{print \$2}') = ${linkto} ]",
				}
			}
		}
		absent: {
			if $::lsbdistcodename == 'lenny' {
				exec { "/usr/sbin/update-alternatives --remove ${name} ${linkto}":
					unless => "[ $(basename $(readlink -f /etc/alternatives/${name})) != ${linkto} ]",
				}
			} else {
				exec { "/usr/sbin/update-alternatives --remove ${name} ${linkto}":
					unless => "[ $(update-alternatives --query ${name} | grep ^Value | awk '{print \$2}') != ${linkto} ]",
				}
			}
		}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}
}
