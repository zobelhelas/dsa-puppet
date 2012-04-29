class roles::security_master {

	$bind = $::hostname ? {
		default => '',
	}

	$bind6 = $::hostname ? {
		default => '',
	}

	$logfile = '/var/log/ftp/vsftpd-security-master.debian.org.log'

	vsftpd::site { 'security':
		content => template('roles/security_master/vsftpd.conf.erb'),
		logfile => $logfile,
		bind    => $bind,
	}

	if $bind6 {
		vsftpd::site { 'security-v6':
			content => template('roles/security_master/vsftpd.conf.erb'),
			logfile => $logfile,
			bind    => $bind6,
		}
	}
}
