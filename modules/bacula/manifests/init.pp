class bacula {

	$bacula_operator_email    = 'bacula-reports@admin.debian.org'

	$bacula_director_name     = 'debian-dir'
	$bacula_storage_name      = 'debian-sd'
	$bacula_client_name       = "${::fqdn}-fd"
	$bacula_monitor_name      = 'debian-mon'
	$bacula_filestor_name     = 'File'
	$bacula_filestor_device   = 'FileStorage'
	$bacula_pool_name         = 'debian'

	# use IP address for ferm.
	$bacula_director_ip       = '5.153.231.19'
	$bacula_director_address  = 'dinis.debian.org'
	$bacula_director_port     = 9101
	$bacula_storage_address   = 'backuphost.debian.org'
	$bacula_storage_port      = 9103
	$bacula_client_port       = 9102
	$bacula_db_address        = 'danzi.debian.org'
	$bacula_db_port           = 5433

	$bacula_backup_path       = '/srv/bacula'

	$bacula_director_secret   = hkdf('/etc/puppet/secret', "bacula-dir-${::hostname}")
	$bacula_db_secret         = hkdf('/etc/puppet/secret', "bacula-db-${::hostname}")
	$bacula_storage_secret    = hkdf('/etc/puppet/secret', "bacula-sd-${bacula_storage_name}")
	$bacula_client_secret     = hkdf('/etc/puppet/secret', "bacula-fd-${::fqdn}")
	$bacula_monitor_secret    = hkdf('/etc/puppet/secret', "bacula-monitor-${bacula_director_name}")

	$bacula_ca_path           = '/etc/ssl/debian/certs/ca.crt'
	$bacula_ssl_client_cert   = '/etc/ssl/debian/certs/thishost.crt'
	$bacula_ssl_client_key    = '/etc/ssl/debian/keys/thishost.key'
	$bacula_ssl_server_cert   = '/etc/ssl/debian/certs/thishost-server.crt'
	$bacula_ssl_server_key    = '/etc/ssl/debian/keys/thishost-server.key'

	file { '/usr/local/sbin/bacula-idle-restart':
		mode    => '0555',
		source  => 'puppet:///modules/bacula/bacula-idle-restart',
	}

}
