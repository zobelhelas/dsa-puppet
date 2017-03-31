class roles::bugs_mirror {

	rsync::site_systemd { 'bugs_mirror':
		source      => 'puppet:///modules/roles/bugs_mirror/rsyncd.conf',
		max_clients => 100,
	}

	if $::apache2 {
		apache2::site { '009-bugs-mirror.debian.org':
			site   => 'bugs-mirror.debian.org',
			source => 'puppet:///modules/roles/bugs_mirror/bugs-mirror.debian.org',
		}
	}

	file { '/srv/bugs.debian.org/cache/libravatar':
		ensure => directory,
		owner  => 'www-data',
		mode   => '0755',
	}
}
