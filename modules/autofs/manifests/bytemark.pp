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
	file { '/etc/auto.master.d/dsa.autofs':
		source  => "puppet:///modules/autofs/bytemark/auto.master.d-dsa.autofs",
		notify  => Exec['autofs reload']
	}
	file { '/etc/auto.dsa':
		source  => "puppet:///modules/autofs/bytemark/auto.dsa",
		notify  => Exec['autofs reload']
	}

	file { '/srv/mirrors': ensure  => directory }
	file { '/srv/mirrors/debian': ensure  => '/auto.dsa/debian' }
	file { '/srv/mirrors/debian-backports': ensure  => '/auto.dsa/debian-backports' }
	file { '/srv/mirrors/debian-security': ensure  => '/auto.dsa/debian-security' }
}
