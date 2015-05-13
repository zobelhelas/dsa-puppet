class dnsextras::entries {

	file { '/srv/dns.debian.org/puppet-extra':
		ensure => 'directory',
	}

	concat { '/srv/dns.debian.org/puppet-extra/include-debian.org':
		notify  => Exec["rebuild debian.org zone"],
	}


	Concat::Fragment <<| tag == "dnsextra" |>>

	exec { 'rebuild debian.org zone':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		command => '/bin/su - dnsadm -c "/srv/dns.debian.org/bin/update"',
		refreshonly => true,
	}
}
