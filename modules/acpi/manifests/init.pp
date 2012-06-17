class acpi {
	if ! ($::debarchitecture in ['kfreebsd-amd64', 'kfreebsd-i386']) {
		package { 'acpid':
			ensure => installed
		}

		service { 'acpid':
			ensure  => running,
			require => Package['acpid'],
		}

		package { 'acpi-support-base':
			ensure => installed
		}
	}
}
