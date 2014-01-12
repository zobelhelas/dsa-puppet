class roles::sip {
	ssl::service { 'www.debian.org':
	}
	@ferm::rule { 'dsa-sip-ws-ip4':
		domain      => 'ip',
		description => 'SIP connections (WebSocket; for WebRTC)',
		rule        => 'proto tcp dport (443) ACCEPT'
	}
	@ferm::rule { 'dsa-sip-ws-ip6':
		domain      => 'ip6',
		description => 'SIP connections (WebSocket; for WebRTC)',
		rule        => 'proto tcp dport (443) ACCEPT'
	}
	@ferm::rule { 'dsa-sip-tls-ip4':
		domain      => 'ip',
		description => 'SIP connections (TLS)',
		rule        => 'proto tcp dport (5061) ACCEPT'
	}
	@ferm::rule { 'dsa-sip-tls-ip6':
		domain      => 'ip6',
		description => 'SIP connections (TLS)',
		rule        => 'proto tcp dport (5061) ACCEPT'
	}
	@ferm::rule { 'dsa-turn-ip4':
		domain      => 'ip',
		description => 'TURN connections',
		rule        => 'proto udp dport (3478) ACCEPT'
	}
	@ferm::rule { 'dsa-turn-ip6':
		domain      => 'ip6',
		description => 'TURN connections',
		rule        => 'proto udp dport (3478) ACCEPT'
	}
	@ferm::rule { 'dsa-turn-tls-ip4':
		domain      => 'ip',
		description => 'TURN connections (TLS)',
		rule        => 'proto tcp dport (5349) ACCEPT'
	}
	@ferm::rule { 'dsa-turn-tls-ip6':
		domain      => 'ip6',
		description => 'TURN connections (TLS)',
		rule        => 'proto tcp dport (5349) ACCEPT'
	}
	@ferm::rule { 'dsa-rtp-ip4':
		domain      => 'ip',
		description => 'RTP streams',
		rule        => 'proto udp dport (49152:65535) ACCEPT'
	}
	@ferm::rule { 'dsa-rtp-ip6':
		domain      => 'ip6',
		description => 'RTP streams',
		rule        => 'proto udp dport (49152:65535) ACCEPT'
	}
}
