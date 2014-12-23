class roles::search_frontend {
	stunnel4::client { 'searchsync':
		accept      => '127.0.0.1:7010',
		connecthost => 'wolkenstein.debian.org',
		connectport => 17010,
	}
}
