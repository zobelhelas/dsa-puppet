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
	file { '/etc/ntp.keys.d/ntpkey_iff_dijkstra':
		source => 'puppet:///modules/ntp/ntpkey_iff_dijkstra.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_luchesi':
		source => 'puppet:///modules/ntp/ntpkey_iff_luchesi.pub',
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_ravel':
		ensure => absent,
	}
	file { '/etc/ntp.keys.d/ntpkey_iff_busoni':
		ensure => absent,
	}
}
