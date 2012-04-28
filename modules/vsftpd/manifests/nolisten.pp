class vsftpd::nolisten inherits vsftpd {

	$noop = $::hostname ? {
		villa    => false,
		lobos    => false,
		saens    => false,
		schein   => false,
		steffani => false,
		wieck    => false,
		default  => true
	}

	Service['vsftpd'] {
		ensure => stopped,
		noop   => $noop,
	}

	Service['vsftpd']->Service['xinetd']

	file { '/etc/vsftpd.conf':
		noop    => $noop,
		content => "listen=NO\n",
		notify  => Service['vsftpd']
	}
}
