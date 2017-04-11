class ferm::ftp_conntrack {
	# This also works for jessie hosts, but requires a reboot
	if (versioncmp($::lsbmajdistrelease, '9') >= 0) {
		# Allow non-passive connections to an FTP server
		@ferm::rule { 'dsa-ftp-conntrack-client':
			domain      => '(ip ip6)',
			description => 'ftp client connection tracking',
			table       => 'raw',
			chain       => 'OUTPUT',
			rule        => 'proto tcp dport 21 CT helper ftp'
		}

		# Allow passive connections from an FTP client
		@ferm::rule { 'dsa-ftp-conntrack-server':
			domain      => '(ip ip6)',
			description => 'ftp server connection tracking',
			table       => 'raw',
			chain       => 'PREROUTING',
			rule        => 'proto tcp dport 21 CT helper ftp'
		}
	} else {
		ferm::module { 'nf_conntrack_ftp': }
	}
}
