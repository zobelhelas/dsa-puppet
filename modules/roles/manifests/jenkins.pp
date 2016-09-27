class roles::jenkins {
	include apache2::ssl
	apache2::module { 'proxy_http': }

	apache2::site { '010-jenkins.debian.org':
		site    => 'jenkins.debian.org',
		source => 'puppet:///modules/roles/jenkins/jenkins.debian.org',
	}

	ssl::service { 'jenkins.debian.org':
		notify  => Exec['service apache2 reload'],
		key => true,
	}
}
