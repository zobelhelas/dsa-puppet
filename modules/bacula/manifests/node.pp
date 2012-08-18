define bacula::node() {

	include bacula

	$bacula_client_port   = $bacula::bacula_client_port

	$bacula_client_name   = "${name}-fd"
	$bacula_client_secret = hkdf('/etc/puppet/secret', "bacula-fd-${name}")
	$client               = $name

	file { "/etc/bacula/conf.d/${name}.conf":
		content => template('bacula/per-client.conf.erb'),
		mode    => '0440',
		group   => bacula,
		notify  => Exec['bacula-director reload']
	}
}

