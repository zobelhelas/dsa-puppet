class acpi {
	if ! ($::debarchitecture in ['kfreebsd-amd64', 'kfreebsd-i386']) {
		if ($::lsbmajdistrelease >= '8') {
			package { 'acpid':
				ensure => purged
			}

			package { 'acpi-support-base':
				ensure => purged
			}
		} elsif ($::kvmdomain) {
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
}
