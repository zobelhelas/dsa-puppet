class acpi {
	if ! ($::debarchitecture in ['kfreebsd-amd64', 'kfreebsd-i386']) {
		if (versioncmp($::lsbmajdistrelease, '8') >= 0) {
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
