define bacula::node() {
	include bacula::director

	$bacula_client_name   = "${name}-fd"
	$bacula_client_secret = hmac('/etc/puppet/secret', "bacula-fd-${name}")
	$client               = $name

	file { "/etc/bacula/conf.d/${name}.conf":
		content => template('bacula/per-client.conf.erb'),
		mode    => '0440',
		group   => bacula,
		notify  => Service['bacula-director']
	}
}

