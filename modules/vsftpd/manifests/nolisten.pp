class vsftpd::nolisten {

	Service['vsftpd'] {
		ensure => stopped
	}

	file { '/etc/vsftpd.conf':
		content => 'listen=NO'
		notify  => Service['vsftpd']
	}
}
