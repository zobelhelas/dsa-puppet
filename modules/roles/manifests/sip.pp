class roles::sip {
	@ferm::rule { 'dsa-sip-ws':
		domain      => 'ip',
		description => 'SIP connections (WebSocket; for WebRTC)',
		rule        => 'proto tcp dport (443) ACCEPT'
	}
	@ferm::rule { 'dsa-sip-tls':
		domain      => 'ip',
		description => 'SIP connections (TLS)',
		rule        => 'proto tcp dport (5061) ACCEPT'
	}
	@ferm::rule { 'dsa-turn':
		domain      => 'ip',
		description => 'TURN connections',
		rule        => 'proto udp dport (3478) ACCEPT'
	}
	@ferm::rule { 'dsa-turn-tls':
		domain      => 'ip',
		description => 'TURN connections (TLS)',
		rule        => 'proto tcp dport (5349) ACCEPT'
	}
	@ferm::rule { 'dsa-rtp':
		domain      => 'ip',
		description => 'RTP streams',
		rule        => 'proto udp dport (49152:65535) ACCEPT'
	}
}
