class autofs::common {
	package { 'autofs': ensure => installed }
	package { 'nfs-common': ensure => installed }

	site::linux_module { 'nfs': }
	site::linux_module { 'autofs4': }

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
