class entropykey::remote_consumer ($entropy_provider) inherits entropykey::local_consumer {

	stunnel4::client { 'ekeyd':
		accept      => '127.0.0.1:8888',
		connecthost => $entropy_provider,
		connectport => 18888,
	}
}
