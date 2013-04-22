class roles::mailrelay {
	exim::vdomain { 'admin.debian.org':
		user       => mail_admin,
		group      => mail_admin,
		maildir    => '/org/admin.debian.org/mail/',
		alias_file => 'puppet:///modules/exim/admin.debian.org/aliases'
	}
}
