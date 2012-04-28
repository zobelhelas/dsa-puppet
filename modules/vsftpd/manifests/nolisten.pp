class vsftpd::nolisten inherits vsftpd {

	$noop = $::hostname ? {
		bizet     => false,
		franck    => false,
		gluck     => false,
		lobos     => false,
		ravel     => false,
		saens     => false,
		santoro   => false,
		schein    => false,
		steffani  => false,
		villa     => false,
		wieck     => false,
		morricone => false,
		default   => true
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
