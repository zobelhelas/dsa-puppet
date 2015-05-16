class ntpdate {

	if getfromhash($site::nodeinfo, 'broken-rtc') {
		package { [
			'ntpdate',
			'lockfile-progs'
		]:
			ensure => installed
		}

		$ntpservers = $::hostname ? {
			default => ['czerny.debian.org', 'clementi.debian.org', 'bm-bl1.debian.org', 'bm-bl2.debian.org', 'ubc-bl8.debian.org', 'luchesi.debian.org']
		}

		file { '/etc/default/ntpdate':
			content => template('ntpdate/etc-default-ntpdate.erb'),
		}
	}
}
