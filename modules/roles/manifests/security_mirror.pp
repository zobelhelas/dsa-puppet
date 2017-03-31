class roles::security_mirror {
	include roles::archvsync_base

	$binds = $::hostname ? {
		mirror-anu      => [ '150.203.164.61', '[2001:388:1034:2900::3d]' ],
		mirror-bytemark => [ '5.153.231.46', '[2001:41c8:1000:21::21:46]' ],
		mirror-conova   => [ '217.196.149.233', '[2a02:16a8:dc41:100::233]' ],
		mirror-isc      => [ '149.20.4.14', '[2001:4f8:1:c::14]' ],
		mirror-umn      => [ '128.101.240.215', '[2607:ea00:101:3c0b::1deb:215]' ],
		default         => [ '[::]' ],
	}

	file { '/srv/mirrors/debian-security':
		ensure => link,
		target => '../ftp.root/debian-security',
	}
	file { '/srv/ftp.root':
		ensure  => directory,
	}
	file { '/srv/ftp.root/.nobackup':
		ensure  => present,
		content => '',
	}
	file { '/srv/ftp.root/debian-security':
		ensure => directory,
		owner  => 1176, # archvsync
		group  => 1176, # archvsync
		mode   => '0755',
	}

	include apache2::expires
	include apache2::rewrite

	apache2::site { '010-security.debian.org':
		site   => 'security.debian.org',
		content => template('roles/security_mirror/security.debian.org.erb')
	}

	if has_role('security_mirror_no_ftp') {
		vsftpd::site_systemd { 'security':
			ensure => absent,
			root   => '/nonexistent',
		}
	} else {
		vsftpd::site_systemd { 'security':
			banner       => 'security.debian.org FTP server (vsftpd)',
			logfile      => '/var/log/ftp/vsftpd-security.debian.org.log',
			max_clients  => 200,
			root         => '/srv/ftp.root/',
			binds        => $binds,
		}
	}

	rsync::site_systemd { 'security':
		source      => 'puppet:///modules/roles/security_mirror/rsyncd.conf',
		max_clients => 100,
		binds       => $binds,
	}

	$onion_v4_addr = $::hostname ? {
		mirror-anu => '150.203.164.61',
		mirror-isc => '149.20.4.14',
		mirror-umn => '128.101.240.215',
		villa      => '212.211.132.32',
		lobos      => '212.211.132.250',
		default   => undef,
	}
	if has_role('security_mirror_onion') {
		if ! $onion_v4_addr {
			fail("Do not have an onion_v4_addr set for $::hostname.")
		}

		onion::service { 'security.debian.org':
			port => 80,
			target_port => 80,
			target_address => $onion_v4_addr,
		}
	}
}
