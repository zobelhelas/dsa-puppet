class rng-tools {
	if FileTest.exist?("/dev/hwrng") {
		package { 'rng-tools':
			ensure => installed
		}
		service { 'rng-tools':
			ensure  => running,
			require => Package['rng-tools']
		}
	}
}
