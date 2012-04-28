class roles::backports_master {

	include roles::backports_mirror

	$bind = $::hostname ? {
		default => '',
	}

	$bind6 = $::hostname ? {
		default => '',
	}

	vsftpd::site { 'backports':
		source  => 'puppet:///modules/roles/backports_master/vsftpd.conf',
		logfile => '/var/log/ftp/vsftpd-backports-master.debian.org.log',
		bind    => $bind,
	}

	if $bind6 {
		vsftpd::site { 'backports-v6':
			source  => 'puppet:///modules/roles/security_mirror/vsftpd.conf',
			logfile => '/var/log/ftp/vsftpd-backports-master.debian.org.log',
			bind    => $bind6,
		}
	}

}
