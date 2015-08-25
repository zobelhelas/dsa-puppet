class roles::sso_rp {
	file { '/var/lib/dsa':
		ensure => directory,
		mode   => '02755'
	}
	file { '/var/lib/dsa/sso':
		ensure => directory,
		mode   => '02755'
	}
	file { '/var/lib/dsa/sso/ca.crl':
		content => template('roles/sso_rp/ca.crl.erb'),
	}
	file { '/var/lib/dsa/sso/ca.pem':
		source => 'puppet:///modules/roles/sso_rp/ca.pem',
	}

}
