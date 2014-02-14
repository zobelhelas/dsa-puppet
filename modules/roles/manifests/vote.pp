class roles::vote {
	ssl::service { 'vote.debian.org':
		notify => Service['apache2'],
	}
}
