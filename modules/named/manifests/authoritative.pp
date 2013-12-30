class named::authoritative inherits named {
	file { '/etc/bind/named.conf.debian-zones':
		content => template('named/named.conf.debian-zones.erb'),
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
	file { '/etc/bind/named.conf.puppet-shared-keys':
		mode    => '0640',
		content => template('named/named.conf.puppet-shared-keys.erb'),
		owner   => root,
		group   => bind,
		notify  => Service['bind9'],
	}
}
