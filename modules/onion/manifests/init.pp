class onion {
	package { 'tor':
		ensure => installed,
	}
	service { 'tor':
		ensure => running,
		require => Package['tor'],
	}
	exec { 'service tor reload':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		command     => 'service tor reload',
		refreshonly => true,
		require =>  Package['tor'],
	}
	file { '/var/lib/tor/onion':
		require => Package['tor'],
		ensure  => directory,
		owner => 'debian-tor',
		group => 'debian-tor',
		mode => '02700',
	}

	concat { '/etc/tor/torrc':
		notify  => Exec['service tor reload'],
		require => Package['tor'],
	}
	concat::fragment { 'onion::torrc_header':
		target  => "/etc/tor/torrc",
		order   => '05',
		content => template("onion/torrc-header.erb"),
	}
}
