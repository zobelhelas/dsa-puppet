define site::sysctl ($key, $value, $ensure = present) {
	include site
	case $ensure {
		present: {}
		absent:  {}
		default: { fail ( "Unknown ensure value: '$ensure'" ) }
	}

	file {
		"/etc/sysctl.d/${name}.conf":
			ensure  => $ensure,
			owner   => root,
			group   => root,
			mode    => '0644',
			content => "${key} = ${value}\n",
			notify  => Service['procps']
	}
}
