class roles::bugs_mirror {

	rsync::site { 'bugs_mirror':
		source      => 'puppet:///modules/roles/bugs_mirror/rsyncd.conf',
		max_clients => 100,
	}
}
