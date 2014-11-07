define site::alternative ($linkto, $ensure = present) {
	case $ensure {
		present: {
			exec { "/usr/bin/update-alternatives --set ${name} ${linkto}":
				unless => "[ $(update-alternatives --query ${name} | grep ^Value | awk '{print \$2}') = ${linkto} ]",
			}
		}
		absent: {
			exec { "/usr/bin/update-alternatives --remove ${name} ${linkto}":
				unless => "[ $(update-alternatives --query ${name} | grep ^Value | awk '{print \$2}') != ${linkto} ]",
			}
		}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}
}
