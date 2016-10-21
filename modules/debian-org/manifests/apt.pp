# == Class: debian-org
#
# Stuff common to all debian.org servers
#
class debian-org::apt {
	if $::lsbmajdistrelease <= 7 {
		$mungedcodename = $::lsbdistcodename
	} elsif ($::debarchitecture in ['kfreebsd-amd64', 'kfreebsd-i386']) {
		$mungedcodename = "${::lsbdistcodename}-kfreebsd"
	} else {
		$mungedcodename = $::lsbdistcodename
	}

	if $::lsbmajdistrelease <= 8 {
		$fallbackmirror = 'http://cdn-fastly.deb.debian.org/debian/'
	} else {
		$fallbackmirror = 'http://deb.debian.org/debian/'
	}

	if getfromhash($site::nodeinfo, 'hoster', 'mirror-debian') {
		$mirror = [ getfromhash($site::nodeinfo, 'hoster', 'mirror-debian'), $fallbackmirror ]
	} else {
		$mirror = [ $fallbackmirror ]
	}

	site::aptrepo { 'debian':
		url        => $mirror,
		suite      => [ $mungedcodename, "${::lsbdistcodename}-backports", "${::lsbdistcodename}-updates" ],
		components => ['main','contrib','non-free']
	}
	site::aptrepo { 'security':
		url        => [ 'http://security-cdn.debian.org/', 'http://security.debian.org/' ],
		suite      => "${mungedcodename}/updates",
		components => ['main','contrib','non-free']
	}
	site::aptrepo { 'db.debian.org':
		url        => 'http://db.debian.org/debian-admin',
		suite      => [ 'debian-all', $::lsbdistcodename ],
		components => 'main',
		key        => 'puppet:///modules/debian-org/db.debian.org.gpg',
	}

	if ($::hostname in [] or $::debarchitecture in ['kfreebsd-amd64', 'kfreebsd-i386']) {
		site::aptrepo { 'proposed-updates':
			url        => $mirror,
			suite      => "${mungedcodename}-proposed-updates",
			components => ['main','contrib','non-free']
		}
	} else {
		site::aptrepo { 'proposed-updates':
			ensure => absent,
		}
	}

	site::aptrepo { 'debian-cdn':
		ensure => absent,
	}
	site::aptrepo { 'debian.org':
		ensure => absent,
	}
	site::aptrepo { 'debian2':
		ensure => absent,
	}
	site::aptrepo { 'backports2.debian.org':
		ensure => absent,
	}
	site::aptrepo { 'backports.debian.org':
		ensure => absent,
	}
	site::aptrepo { 'volatile':
		ensure => absent,
	}
	site::aptrepo { 'db.debian.org-suite':
		ensure => absent,
	}
	site::aptrepo { 'debian-lts':
		ensure => absent,
	}




	file { '/etc/apt/trusted-keys.d':
		ensure => absent,
		force  => true,
	}

	file { '/etc/apt/trusted.gpg':
		mode    => '0600',
		content => "",
	}

	file { '/etc/apt/preferences':
		source => 'puppet:///modules/debian-org/apt.preferences',
	}
	file { '/etc/apt/apt.conf.d/local-compression':
		source => 'puppet:///modules/debian-org/apt.conf.d/local-compression',
	}
	file { '/etc/apt/apt.conf.d/local-recommends':
		source => 'puppet:///modules/debian-org/apt.conf.d/local-recommends',
	}
	file { '/etc/apt/apt.conf.d/local-pdiffs':
		source => 'puppet:///modules/debian-org/apt.conf.d/local-pdiffs',
	}
	file { '/etc/apt/apt.conf.d/local-langs':
		source => 'puppet:///modules/debian-org/apt.conf.d/local-langs',
	}

	exec { 'apt-get update':
		path    => '/usr/bin:/usr/sbin:/bin:/sbin',
		onlyif  => '/usr/local/bin/check_for_updates',
		require => File['/usr/local/bin/check_for_updates']
	}
	Exec['apt-get update']->Package<| tag == extra_repo |>
}
