class ntpdate {

	if getfromhash($site::nodeinfo, 'broken-rtc') {
		package { [
			'ntpdate',
			'lockfile-progs'
		]:
			ensure => installed
		}

		$ntpservers = $::hostname ? {
			ancina  => 'ntp.ugent.be',
			default => ['merikanto.debian.org','orff.debian.org','ravel.debian.org','busoni.debian.org']
		}

		file { '/etc/default/ntpdate':
			content => template('ntpdate/etc-default-ntpdate.erb'),
		}
	}
}
