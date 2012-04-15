class exim::mx inherits exim {
	include clamav
	include postgrey

	file { '/etc/exim4/ccTLD.txt':
		source => 'puppet:///modules/exim/common/ccTLD.txt',
	}
	file { '/etc/exim4/surbl_whitelist.txt':
		source => 'puppet:///modules/exim/common/surbl_whitelist.txt',
	}
	file { '/etc/exim4/exim_surbl.pl':
		source  => 'puppet:///modules/exim/common/exim_surbl.pl',
		notify  => Service['exim4'],
	}

	@ferm::rule { 'dsa-exim-submission':
		description => 'Allow SMTP',
		rule        => '&SERVICE_RANGE(tcp, submission, $SMTP_SOURCES)'
	}
	@ferm::rule { 'dsa-exim-v6-submission':
		description => 'Allow SMTP',
		domain      => 'ip6',
		rule        => '&SERVICE_RANGE(tcp, submission, $SMTP_V6_SOURCES)',
	}

	package { 'nagios-plugins-standard':
		ensure => installed,
	}
}
