define rsync::site_systemd (
	$binds=['[::]'],
	$source=undef,
	$content=undef,
	$max_clients=200,
	$ensure=present,
	$sslname=undef,
) {
	include rsync

	$fname_real_rsync = "/etc/rsyncd-${name}.conf"
	$fname_real_stunnel = "/etc/rsyncd-${name}-stunnel.conf"

	case $ensure {
		present,absent: {}
		default: { fail ( "Invald ensure `${ensure}' for ${name}" ) }
	}

	$ensure_service = $ensure ? {
		present => running,
		absent  => stopped,
	}

	$ensure_enable = $ensure ? {
		present => true,
		absent  => false,
	}

	file { $fname_real_rsync:
		ensure  => $ensure,
		content => $content,
		source  => $source,
		owner   => 'root',
		group   => 'root',
		mode    => '0444',
	}

	file { "/etc/systemd/system/rsyncd-${name}@.service":
		ensure  => $ensure,
		content => template('rsync/systemd-rsyncd.service.erb'),
		owner   => 'root',
		group   => 'root',
		mode    => '0444',
		require => File[$fname_real_rsync],
		notify  => Exec['systemctl daemon-reload'],
	}

	file { "/etc/systemd/system/rsyncd-${name}.socket":
		ensure  => $ensure,
		content => template('rsync/systemd-rsyncd.socket.erb'),
		owner   => 'root',
		group   => 'root',
		mode    => '0444',
		notify  => [
			Exec['systemctl daemon-reload'],
			Service["rsyncd-${name}.socket"],
		],
	}

	service { "rsyncd-${name}.socket":
		ensure   => $ensure_service,
		enable   => $ensure_enable,
		require  => [
			Exec['systemctl daemon-reload'],
			File["/etc/systemd/system/rsyncd-${name}@.service"],
			File["/etc/systemd/system/rsyncd-${name}.socket"],
		],
		provider => systemd,
	}

	if $sslname {
		file { $fname_real_stunnel:
			ensure  => $ensure,
			content => template('rsync/systemd-rsyncd-stunnel.conf.erb'),
			owner   => 'root',
			group   => 'root',
			mode    => '0444',
			require => File["/etc/ssl/debian/certs/${sslname}.crt-chained"],
		}

		file { "/etc/systemd/system/rsyncd-${name}-stunnel@.service":
			ensure  => $ensure,
			content => template('rsync/systemd-rsyncd-stunnel.service.erb'),
			owner   => 'root',
			group   => 'root',
			mode    => '0444',
			require => File[$fname_real_stunnel],
			notify  => Exec['systemctl daemon-reload'],
		}

		file { "/etc/systemd/system/rsyncd-${name}-stunnel.socket":
			ensure  => $ensure,
			content => template('rsync/systemd-rsyncd-stunnel.socket.erb'),
			owner   => 'root',
			group   => 'root',
			mode    => '0444',
			notify  => [
				Exec['systemctl daemon-reload'],
				Service["rsyncd-${name}-stunnel.socket"]
			],
		}

		service { "rsyncd-${name}-stunnel.socket":
			ensure   => $ensure_service,
			enable   => $ensure_enable,
			require  => [
				Exec['systemctl daemon-reload'],
				File["/etc/systemd/system/rsyncd-${name}-stunnel@.service"],
				File["/etc/systemd/system/rsyncd-${name}-stunnel.socket"],
				Service["rsyncd-${name}.socket"],
			],
			provider => systemd,
		}

		@ferm::rule { "rsync-${name}-ssl":
			domain      => '(ip ip6)',
			description => 'Allow rsync access',
			rule        => '&SERVICE(tcp, 1873)',
		}

		dnsextras::tlsa_record{ "tlsa-${sslname}-1873":
			zone     => 'debian.org',
			certfile => [
				"/etc/puppet/modules/ssl/files/servicecerts/${sslname}.crt",
				"/etc/puppet/modules/ssl/files/from-letsencrypt/${sslname}.crt",
			],
			port     => 1873,
			hostname => $sslname,
		}
	}

	xinetd::service { [ "rsync-${name}", "rsync-${name}6", "rsync-${name}-ssl", "rsync-${name}-ssl6" ]:
		ensure  => absent,
		id      => 'unused',
		server  => 'unused',
		service => 'unused',
		ferm    => false,
	}
}
