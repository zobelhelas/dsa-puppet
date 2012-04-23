class named::recursor inherits named {

	file { '/etc/bind/named.conf.options':
		content => template('named/named.conf.options.erb'),
		notify  => Service['bind9'],
	}
}
