class roles::search_backend {
	stunnel4::server { 'searchsync':
		accept      => '17010',
		connect     => 7010,
	}
}
