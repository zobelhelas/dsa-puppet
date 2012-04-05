class ntpdate {

	if getfromhash($site::nodeinfo, 'broken-rtc') {
		package { [
			'ntpdate',
			'lockfile-progs'
		]:
			ensure => installed
		}

		file { '/etc/default/ntpdate':
			content => template('ntpdate/etc-default-ntpdate.erb'),
		}
	}
}
