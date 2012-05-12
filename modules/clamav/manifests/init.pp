class clamav {
	package { [
			'clamav-daemon',
			'clamav-freshclam',
			'clamav-unofficial-sigs'
		]:
			ensure => installed
	}

	file { [
		'/var/lib/clamav/mbl.ndb',
		'/var/lib/clamav/MSRBL-Images.hdb',
		'/var/lib/clamav/MSRBL-SPAM.ndb',
	]:
		ensure  => absent
	}
	file { '/etc/clamav-unofficial-sigs.dsa.conf':
		require => Package['clamav-unofficial-sigs'],
		source  => [ 'puppet:///modules/clamav/clamav-unofficial-sigs.dsa.conf' ]
	}
	file { '/etc/clamav-unofficial-sigs.conf':
		require => Package['clamav-unofficial-sigs'],
		source  => [ 'puppet:///modules/clamav/clamav-unofficial-sigs.conf' ]
	}

}
