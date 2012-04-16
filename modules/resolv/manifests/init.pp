class resolv {

	$ns   = hiera('nameservers')
	$sp   = hiera('searchpaths')
	$opts = hiera('resolvoptions')

	file { '/etc/resolv.conf':
			content => template('resolv/resolv.conf.erb');
	}
}
