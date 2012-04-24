class vsftpd::nolisten inherits vsftpd {

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
