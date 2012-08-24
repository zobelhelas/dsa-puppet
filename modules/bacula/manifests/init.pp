class bacula {

	$bacula_operator_email    = 'debian-admin@debian.org'

	$bacula_director_name     = 'debian-dir'
	$bacula_storage_name      = 'debian-sd'
	$bacula_client_name       = "${::fqdn}-fd"
	$bacula_monitor_name      = 'debian-mon'
	$bacula_filestor_name     = 'File'
	$bacula_filestor_device   = 'FileStorage'
	$bacula_pool_name         = 'debian'

	# use IP address for ferm.
	$bacula_director_ip       = '206.12.19.139'
	$bacula_director_address  = 'dinis.debian.org'
	$bacula_director_port     = 9101
	$bacula_storage_address   = 'beethoven.debian.org'
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
}
