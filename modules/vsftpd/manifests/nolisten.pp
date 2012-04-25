class vsftpd::nolisten inherits vsftpd {

	Service['vsftpd'] {
		ensure => stopped,
		noop   => true,
	}

	Service['vsftpd']->Service['xinetd']

	file { '/etc/vsftpd.conf':
		noop    => true,
		content => 'listen=NO',
		notify  => Service['vsftpd']
	}
}
