class roles::ftp_upload {

	$bind = $::hostname ? {
		kassia  => '::ffff:130.89.149.224',
		default => '',
	}

	$bind6 = $::hostname ? {
		kassia  => '2001:610:1908:a000:21b:78ff:fe75:3d46',
		default => '',
	}

	vsftpd::site { 'ftp-upload':
		banner     => 'ftp.upload.debian.org FTP server',
		logfile    => '/var/log/ftp/vsftpd-ftp.upload.debian.org.log',
		writable   => true,
		chown_user => dak,
		bind       => $bind,
		root       => '/srv/upload.debian.org/ftp',
	}

	if $bind6 {
		vsftpd::site { 'ftp-upload-v6':
			banner     => 'ftp.upload.debian.org FTP server',
			logfile    => '/var/log/ftp/vsftpd-ftp.upload.debian.org.log',
			writable   => true,
			chown_user => dak,
			bind       => $bind6,
			root       => '/srv/upload.debian.org/ftp',
		}
	}
}
