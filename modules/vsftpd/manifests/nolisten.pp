class vsftpd::nolisten {

	Service['vsftpd'] {
		ensure => stopped,
		noop   => true,
	}

	file { '/etc/vsftpd.conf':
		noop    => true,
		content => 'listen=NO',
		notify  => Service['vsftpd']
	}
}
