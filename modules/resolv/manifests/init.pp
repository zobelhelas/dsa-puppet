class resolv {

	$ns = hiera('nameservers')
	$sp = hiera('searchpaths')

	file { '/etc/resolv.conf':
			content => template('resolv/resolv.conf.erb');
	}
}
