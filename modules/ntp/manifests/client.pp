class ntp::client {
	file { '/etc/default/ntp':
		source => 'puppet:///modules/ntp/etc-default-ntp',
		require => Package['ntp'],
		notify  => Service['ntp']
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_czerny':
		source => 'puppet:///modules/ntp/ntpkey_iff_czerny.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_clementi':
		source => 'puppet:///modules/ntp/ntpkey_iff_clementi.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_bm-bl1':
		source => 'puppet:///modules/ntp/ntpkey_iff_bm-bl1.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_bm-bl2':
		source => 'puppet:///modules/ntp/ntpkey_iff_bm-bl2.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_ubc-bl2':
		source => 'puppet:///modules/ntp/ntpkey_iff_ubc-bl2.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_ubc-bl6':
		source => 'puppet:///modules/ntp/ntpkey_iff_ubc-bl6.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_dijkstra':
		ensure => absent,
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_luchesi':
		ensure => absent,
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_ravel':
		ensure => absent,
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_busoni':
		ensure => absent,
	}
}
