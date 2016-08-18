class roles::tracker {
	ssl::service { 'tracker.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
	onion::service { 'tracker.debian.org': port => 80, target_address => 'tracker.debian.org', target_port => 80, direct => true }
}
