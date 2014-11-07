class portforwarder {
	# do not depend on xinetd, yet.  it might uninstall other inetds
	# for now this will have to be done manually
	file { '/etc/ssh/userkeys/portforwarder':
		content => template('portforwarder/authorized_keys.erb'),
	}
	file { '/etc/xinetd.d':
		ensure  => directory,
		owner   => root,
		group   => root,
		mode    => '0755',
	}
	file { '/etc/xinetd.d/dsa-portforwader':
		content => template('portforwarder/xinetd.erb'),
		notify  => Exec['service xinetd reload']
	}

	exec { 'service xinetd reload':
		refreshonly => true,
	}
}
