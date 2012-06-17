# = Class: dacs
#
# This class installs and configures dacs for web auth
#
# == Sample Usage:
#
#   include dacs
#
class dacs {
	package { 'dacs':
		ensure => installed,
	}
	package { 'libapache2-mod-dacs':
		ensure => installed,
	}

	File {
		owner => root,
		group => www-data,
		mode  => '0640',
	}

	file { '/var/log/dacs':
		ensure  => directory,
		mode    => '0770',
		purge   => true,
	}
	file { [
			'/etc/dacs/federations',
			'/etc/dacs/federations/debian.org/',
			'/etc/dacs/federations/debian.org/DEBIAN',
			'/etc/dacs/federations/debian.org/DEBIAN/acls',
			'/etc/dacs/federations/debian.org/DEBIAN/groups',
			'/etc/dacs/federations/debian.org/DEBIAN/groups/DACS'
		]:
		ensure  => directory,
		mode    => '0750',
		require => Package['libapache2-mod-dacs'],
		purge   => true
	}
	file { '/etc/dacs/federations/site.conf':
		source  => 'puppet:///modules/dacs/common/site.conf',
	}
	file { '/etc/dacs/federations/debian.org/DEBIAN/dacs.conf':
		source  => [ "puppet:///modules/dacs/per-host/${::fqdn}/dacs.conf",
			'puppet:///modules/dacs/common/dacs.conf', ],
	}
	file { '/etc/dacs/federations/debian.org/DEBIAN/acls/revocations':
		source  => 'puppet:///modules/dacs/common/revocations',
	}
	file { '/etc/dacs/federations/debian.org/DEBIAN/groups/DACS/jurisdictions.grp':
		source  => 'puppet:///modules/dacs/common/jurisdictions.grp',
	}
	file { '/etc/dacs/federations/debian.org/DEBIAN/acls/acl-noauth.0':
		source  => [ "puppet:///modules/dacs/per-host/${::fqdn}/acl-noauth.0",
			'puppet:///modules/dacs/common/acl-noauth.0' ],
		notify  => Exec['dacsacl']
	}
	file { '/etc/dacs/federations/debian.org/DEBIAN/acls/acl-private.0':
		source  => [ "puppet:///modules/dacs/per-host/${::fqdn}/acl-private.0",
			'puppet:///modules/dacs/common/acl-private.0' ],
		notify  => Exec['dacsacl']
	}
	file { '/etc/dacs/federations/debian.org/federation_keyfile':
		source  => 'puppet:///modules/dacs/private/debian.org_federation_keyfile',
	}
	file { '/etc/dacs/federations/debian.org/DEBIAN/jurisdiction_keyfile':
		source  => 'puppet:///modules/dacs/private/DEBIAN_jurisdiction_keyfile',
	}

	exec { 'dacsacl':
		command     => 'dacsacl -sc /etc/dacs/federations/site.conf -c /etc/dacs/federations/debian.org/DEBIAN/dacs.conf -uj DEBIAN && chown root:www-data /etc/dacs/federations/debian.org/DEBIAN/acls/INDEX',
		refreshonly => true,
	}

}
