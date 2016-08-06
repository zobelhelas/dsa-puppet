class roles::dgit_git {
	ssl::service { 'git.dgit.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}

	apache2::site { '010-git.dgit.debian.org':
		site    => 'git.dgit.debian.org',
		source => 'puppet:///modules/roles/dgit/git.dgit.debian.org',
	}

}
