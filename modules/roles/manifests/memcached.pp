class roles::memcached {

	class { '::memcached':
		max_memory => 2048,
		listen_ip  => '127.0.0.1',
	}
}
