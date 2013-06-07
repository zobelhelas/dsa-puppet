class dnsextras::entries {
	file { '/srv/dns.debian.org/puppet-extra':
		ensure => 'directory',
	}

	concat { '/srv/dns.debian.org/puppet-extra/include-debian.org':
		#require => Package['exim4-daemon-heavy']
		# notify  => Service["nagios"],
	}


	Concat::Fragment <<| tag == "dnsextra" |>>
}
