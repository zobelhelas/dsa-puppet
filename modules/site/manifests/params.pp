class site::params {
	$puppetversion = $::hostname ? {
		handel  => '2.7.14-1~bpo60+1',
		default => '2.6.2-5+squeeze5',
	}
}
