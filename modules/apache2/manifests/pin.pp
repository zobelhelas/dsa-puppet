define apache2::pin () {
	$snippet = gen_hpkp_pin($name)

	concat::fragment { "puppet-ssl-key-pins-header-${name}":
		target => '/etc/apache2/conf-available/puppet-ssl-key-pins.conf',
		content => $snippet,
	}
}
