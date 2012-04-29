class vsftpd::nolisten inherits vsftpd {

	Service['vsftpd'] {
		ensure => stopped,
	}

	Service['vsftpd']->Service['xinetd']

	file { '/etc/vsftpd.conf':
		content => "listen=NO\n",
		notify  => Service['vsftpd']
	}
}
