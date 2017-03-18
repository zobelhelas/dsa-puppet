define bacula::storage_per_node() {

	include bacula

	$bacula_filestor_device = $bacula::bacula_filestor_device
	$bacula_filestor_name   = $bacula::bacula_filestor_name
	$bacula_backup_path     = $bacula::bacula_backup_path

	$bacula_client_name   = "${name}-fd"
	$client               = $name

	file {
		"/etc/bacula/storage-conf.d/${name}.conf":
			content => template('bacula/storage-per-client.conf.erb'),
			mode    => '0440',
			group   => bacula,
			notify  => Exec['bacula-sd restart-when-idle'],
			;
		"${bacula_backup_path}/${name}":
			ensure  => directory,
			mode    => '0755',
			owner   => bacula,
			group   => bacula,
			;
	}
}

