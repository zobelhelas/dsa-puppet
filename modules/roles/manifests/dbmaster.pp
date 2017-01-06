# = Class: roles::dbmaster
#
# Setup for db.debian.org master host
#
# == Sample Usage:
#
#   include roles::dbmaster
#
class roles::dbmaster {

	include roles::pubsub::parameters

	$rabbit_password = $roles::pubsub::parameters::rabbit_password

	ssl::service { 'db.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
		tlsaport => [443, 389, 636],
	}

	file { "/etc/ldap/db.debian.org.key":
	       ensure => present,
	       mode   => '0440',
	       group  => 'openldap',
	       source => 'puppet:///modules/ssl/from-letsencrypt/db.debian.org.key',
	       links  => follow,
	}

	roles::pubsub::config { 'generate':
		key      => 'dsa-udgenerate',
		exchange => dsa,
		topic    => 'dsa.ud.replicate',
		vhost    => dsa,
		username => $::fqdn,
		password => $rabbit_password
	}
}
