class postfix {
	munin::check { 'ps_exim4':       ensure => absent }
	munin::check { 'exim_mailqueue': ensure => absent }
	munin::check { 'exim_mailstats': ensure => absent }

	munin::check { 'postfix_mailqueue': }
	munin::check { 'postfix_mailstats': }
	munin::check { 'postfix_mailvolume': }
	munin::check { 'ps_smtp': script => 'ps_' }
	munin::check { 'ps_smtpd': script => 'ps_' }

	@ferm::rule {
		domain      => '(ip ip6)',
		description => 'Allow smtp access',
		rule        => '&SERVICE(tcp, 25)'
	}
}
