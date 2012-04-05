class ferm::ftp {
	@ferm::rule { 'dsa-ftp':
		domain      => '(ip ip6)',
		description => 'Allow ftp access',
		rule        => '&SERVICE(tcp, 21)',
	}
}
