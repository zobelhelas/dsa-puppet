define site::alternative ($linkto, $ensure = present) {
	case $ensure {
		present: {
			exec { "/usr/sbin/update-alternatives --set ${name} ${linkto}":
				unless => "[ $(update-alternatives --query ${name} | grep ^Value | awk '{print \$2}') = ${linkto} ]",
			}
		}
		absent: {
			exec { "/usr/sbin/update-alternatives --remove ${name} ${linkto}":
				unless => "[ $(update-alternatives --query ${name} | grep ^Value | awk '{print \$2}') != ${linkto} ]",
			}
		}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}
}
