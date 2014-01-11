class roles::sip {
	@ferm::rule { 'dsa-sip-ws':
		domain      => 'ip',
		description => 'SIP over WebSocket (for WebRTC)',
		rule        => 'proto tcp mod state state (NEW) dport (443) ACCEPT'
	}
	@ferm::rule { 'dsa-sip':
		domain      => 'ip',
		description => 'SIP connections (TLS)',
		rule        => 'proto tcp mod state state (NEW) dport (5061) ACCEPT'
	}
	@ferm::rule { 'dsa-turn':
		domain      => 'ip',
		description => 'TURN connections (TLS)',
		rule        => 'proto tcp mod state state (NEW) dport (5349) ACCEPT'
	}
	@ferm::rule { 'dsa-rtp':
		domain      => 'ip',
		description => 'RTP streams',
		rule        => 'proto udp mod state state (NEW) dport (49152:65535) ACCEPT'
	}
}
