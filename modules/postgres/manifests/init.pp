class postgres {
	munin::check { 'postgres_bgwriter': }
	munin::check { 'postgres_connections_db': }
	munin::check { 'postgres_cache_ALL':
		script => 'postgres_cache_'
	}
	munin::check { 'postgres_querylength_ALL':
		script => 'postgres_querylength_'
	}
	munin::check { 'postgres_size_ALL':
		script => 'postgres_size_'
	}

	file { '/etc/munin/plugin-conf.d/local-postgres':
		source  => 'puppet:///modules/postgres/plugin.conf',
	}
}
