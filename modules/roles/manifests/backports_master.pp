class roles::backports_master {

	include roles::backports_mirror

	$bind = $::hostname ? {
		default => '',
	}

	$bind6 = $::hostname ? {
		default => '',
	}

	$logfile = '/var/log/ftp/vsftpd-backports-master.debian.org.log'

	vsftpd::site { 'backports':
		content => template('roles/backports_master/vsftpd.conf.erb'),
		logfile => $logfile,
		bind    => $bind,
	}

	if $bind6 {
		vsftpd::site { 'backports-v6':
			source  => template('roles/backports_mirror/vsftpd.conf.erb'),
			logfile => $logfile,
			bind    => $bind6,
		}
	}

}
