class roles::www_master {
		rsync::site { 'www_master':
			source => 'puppet:///modules/roles/www_master/rsyncd.conf',
		}

}
