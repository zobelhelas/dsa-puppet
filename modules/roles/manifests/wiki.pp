class roles::wiki {
	ssl::service { 'wiki.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
	rsync::site_systemd { 'wiki':
		source => 'puppet:///modules/roles/wiki/rsyncd.conf',
	}
}
