define bacula::node() {

	include bacula

	$bacula_client_port   = $bacula::bacula_client_port
	$bacula_ca_path       = $bacula::bacula_ca_path
	$bacula_ssl_client_cert = $bacula::bacula_ssl_client_cert
	$bacula_ssl_client_key  = $bacula::bacula_ssl_client_key

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

