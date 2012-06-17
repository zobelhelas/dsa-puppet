class roles::bugs_search {

	rsync::site { 'bugs_search':
		source      => 'puppet:///modules/roles/bugs_search/rsyncd.conf',
		max_clients => 100,
	}
}
