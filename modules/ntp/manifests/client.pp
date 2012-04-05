class ntp::client {
	file { '/etc/default/ntp':
		source => 'puppet:///modules/ntp/etc-default-ntp',
		require => Package['ntp'],
		notify  => Service['ntp']
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_merikanto':
		source => 'puppet:///modules/ntp/ntpkey_iff_merikanto.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_orff':
		source => 'puppet:///modules/ntp/ntpkey_iff_orff.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_ravel':
		source => 'puppet:///modules/ntp/ntpkey_iff_ravel.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_busoni':
		source => 'puppet:///modules/ntp/ntpkey_iff_busoni.pub',
	}
}
