class named::authoritative inherits named {
	file { '/etc/bind/named.conf.debian-zones':
		source  => 'puppet:///modules/named/common/named.conf.debian-zones',
		notify  => Service['bind9'],
	}
	file { '/etc/bind/named.conf.options':
		content => template('named/named.conf.options.erb'),
		notify  => Service['bind9'],
	}
	file { '/etc/bind/named.conf.shared-keys':
		mode    => '0640',
		owner   => root,
		group   => bind,
	}
}
