class rng_tools {
	if $has_dev_hwrng and !($::kvmdomain and (versioncmp($::lsbmajdistrelease, '9') >= 0)) {
		package { 'rng-tools':
			ensure => installed
		}
		service { 'rng-tools':
			ensure  => running,
			require => Package['rng-tools']
		}
	} else {
		package { 'rng-tools':
			ensure => purged
		}
	}
}
