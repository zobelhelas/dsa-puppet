define stunnel4::generic ($client, $verify, $cafile, $accept, $connect, $crlfile=false, $local=false) {

	include stunnel4

	file { "/etc/stunnel/puppet-${name}.conf":
		content => template('stunnel4/stunnel.conf.erb'),
		notify  => Exec["restart_stunnel_${name}"],
	}

	if $client {
		$certfile = '/etc/ssl/debian/certs/thishost.crt'
		$keyfile = '/etc/ssl/private/thishost.key'
	} else {
		$certfile = '/etc/exim4/ssl/thishost.crt'
		$keyfile = '/etc/exim4/ssl/thishost.key'
	}

	exec { "restart_stunnel_${name}":
		command => "true && cd / && env -i /etc/init.d/stunnel4 restart puppet-${name}",
		require => [
			File['/etc/stunnel/stunnel.conf'],
			File['/etc/init.d/stunnel4'],
			Exec['enable_stunnel4'],
			Exec['kill_file_override'],
			Package['stunnel4']
		],
		subscribe => [ File[$certfile], File[$keyfile] ],
		refreshonly => true,
	}
}
