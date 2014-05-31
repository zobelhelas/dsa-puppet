class autofs::bytemark {
	package { 'autofs': ensure => installed }
	package { 'nfs-common': ensure => installed }

	exec { 'autofs reload':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		command     => 'service autofs reload',
		refreshonly => true,
		require =>  Package['autofs'],
	}


	file { '/etc/auto.master.d':
		ensure  => directory
	}
}
