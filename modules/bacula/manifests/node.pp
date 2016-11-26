define bacula::node($bacula_client_port = $bacula::bacula_client_port) {

	include bacula

	$bacula_pool_name         = $bacula::bacula_pool_name
	$bacula_filestor_name     = $bacula::bacula_filestor_name
	$bacula_filestor_device   = $bacula::bacula_filestor_device
	$bacula_storage_address   = $bacula::bacula_storage_address
	$bacula_storage_port      = $bacula::bacula_storage_port
	$bacula_storage_secret    = $bacula::bacula_storage_secret

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

	file { "/etc/bacula/storages-list.d/${name}.storage":
		content => "$bacula::bacula_filestor_name-$client\n",
		mode    => '0440',
		group   => bacula,
		notify  => Exec['bacula-director reload']
	}
}

