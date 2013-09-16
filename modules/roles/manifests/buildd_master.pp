class roles::buildd_master {
	apache2::site { '010-buildd.debian.org':
		site   => 'buildd.debian.org',
		source => 'puppet:///modules/roles/buildd_master/apache.conf'
	}
}
