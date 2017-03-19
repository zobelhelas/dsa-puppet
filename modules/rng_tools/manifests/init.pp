class rng_tools {
	if $has_dev_hwrng {
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
