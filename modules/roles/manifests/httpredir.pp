class roles::httpredir {
	if $::apache2 {
		apache2::site { '010-httpredir.debian.org':
			site   => 'httpredir.debian.org',
			source => 'puppet:///modules/roles/httpredir/httpredir.debian.org.conf',
		}
	}
}
