class debian-org {

	$debianadmin = [
		'debian-archive-debian-samhain-reports@master.debian.org',
		'debian-admin@ftbfs.de',
		'weasel@debian.org',
		'steve@lobefin.net',
		'paravoid@debian.org'
	]

	package { [
			'klogd',
			'sysklogd',
			'rsyslog',
		]:
		ensure => purged,
	}
	package { [
			'debian.org',
			'dsa-munin-plugins',
		]:
		ensure => installed,
		require => [
			File['/etc/apt/sources.list.d/db.debian.org.list'],
			Exec['apt-get update']
		]
	}
	package { [
			'apt-utils',
			'bash-completion',
			'dnsutils',
			'less',
			'lsb-release',
			'libfilesystem-ruby1.8',
			'mtr-tiny',
			'nload',
			'pciutils',
		]:
		ensure => installed,
	}

	munin::check { [
			'cpu',
			'entropy',
			'forks',
			'interrupts',
			'iostat',
			'irqstats',
			'load',
			'memory',
			'ntp_offset',
			'ntp_states',
			'open_files',
			'open_inodes',
			'processes',
			'swap',
			'uptime',
			'vmstat',
		]:
	}

	if getfromhash($site::nodeinfo, 'broken-rtc') {
		package { 'fake-hwclock':
			ensure => installed,
			require => [
				File['/etc/apt/sources.list.d/db.debian.org.list'],
				Exec['apt-get update']
			]
		}
	}

	package { 'molly-guard':
		ensure => installed,
	}
	file { '/etc/molly-guard/run.d/10-check-kvm':
		mode    => '0755',
		source  => 'puppet:///modules/debian-org/molly-guard/10-check-kvm',
		require => Package['molly-guard'],
	}
	file { '/etc/molly-guard/run.d/15-acquire-reboot-lock':
		mode    => '0755',
		source  => 'puppet:///modules/debian-org/molly-guard/15-acquire-reboot-lock',
		require => Package['molly-guard'],
	}

	site::aptrepo { 'security':
		url        => 'http://security.debian.org/',
		suite      => "${::lsbdistcodename}/updates",
		components => ['main','contrib','non-free']
	}

	if $::lsbdistcodename != 'wheezy' {
		site::aptrepo { 'backports.debian.org':
			url        => 'http://backports.debian.org/debian-backports/',
			suite      => "${::lsbdistcodename}-backports",
			components => ['main','contrib','non-free']
		}

		if getfromhash($site::nodeinfo, 'hoster', 'mirror-debian') {
			site::aptrepo { 'volatile':
				url        => getfromhash($site::nodeinfo, 'hoster', 'mirror-debian'),
				suite      => "${::lsbdistcodename}-updates",
				components => ['main','contrib','non-free']
			}
		} else {
			site::aptrepo { 'volatile':
				url        => 'http://ftp.debian.org/debian',
				suite      => "${::lsbdistcodename}-updates",
				components => ['main','contrib','non-free']
			}
		}
	}
	site::aptrepo { 'backports.org':
		ensure => absent,
		keyid => '16BA136C',
		key => 'puppet:///modules/debian-org/backports.org.asc',
	}

	site::aptrepo { 'debian.org':
		ensure => absent,
	}

	site::aptrepo { 'db.debian.org':
		url        => 'http://db.debian.org/debian-admin',
		suite      => 'lenny',
		components => 'main',
		key        => 'puppet:///modules/debian-org/db.debian.org.asc',
	}

	if getfromhash($site::nodeinfo, 'hoster', 'mirror-debian') {
		site::aptrepo { 'debian':
			url        => getfromhash($site::nodeinfo, 'hoster', 'mirror-debian'),
			suite      => $::lsbdistcodename,
			components => ['main','contrib','non-free']
		}
	}

	file { '/etc/facter':
		ensure  => directory,
		purge   => true,
		force   => true,
		recurse => true,
		source  => 'puppet:///files/empty/',
	}
	file { '/etc/facter/facts.d':
		ensure => directory,
	}
	file { '/etc/facter/facts.d/debian_facts.yaml':
		content => template('debian-org/debian_facts.yaml.erb')
	}
	file { '/etc/apt/preferences':
		source => 'puppet:///modules/debian-org/apt.preferences',
	}
	file { '/etc/apt/trusted-keys.d/':
		ensure => directory,
		purge  => true,
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
	file { '/etc/timezone':
		source => 'puppet:///modules/debian-org/timezone',
		notify => Exec['dpkg-reconfigure tzdata -pcritical -fnoninteractive'],
	}
	if $::hostname == handel {
		include puppetmaster::db
		$dbpassword = $puppetmaster::db::password
	}
	file { '/etc/puppet/puppet.conf':
		content => template('debian-org/puppet.conf.erb'),
	}
	file { '/etc/default/puppet':
		source => 'puppet:///modules/debian-org/puppet.default',
	}
	file { '/etc/cron.d/dsa-puppet-stuff':
		source => 'puppet:///modules/debian-org/dsa-puppet-stuff.cron',
		require => Package['debian.org'],
	}
	file { '/etc/ldap/ldap.conf':
		require => Package['debian.org'],
		source => 'puppet:///modules/debian-org/ldap.conf',
	}
	file { '/etc/pam.d/common-session':
		require => Package['debian.org'],
		content => template('debian-org/pam.common-session.erb'),
	}
	file { '/etc/pam.d/common-session-noninteractive':
		require => Package['debian.org'],
		content => template('debian-org/pam.common-session-noninteractive.erb'),
	}
	file { '/etc/rc.local':
		mode   => '0755',
		source => 'puppet:///modules/debian-org/rc.local',
		notify => Exec['rc.local start'],
	}
	file { '/etc/dsa':
		ensure => directory,
		mode   => '0755',
	}
	file { '/etc/dsa/cron.ignore.dsa-puppet-stuff':
		source  => 'puppet:///modules/debian-org/dsa-puppet-stuff.cron.ignore',
		require => Package['debian.org']
	}

	# set mmap_min_addr to 4096 to mitigate
	# Linux NULL-pointer dereference exploits
	site::sysctl { 'mmap_min_addr':
		key   => 'vm.mmap_min_addr',
		value => '4096',
	}
	site::alternative { 'editor':
		linkto => '/usr/bin/vim.basic',
	}
	site::alternative { 'view':
		linkto => '/usr/bin/vim.basic',
	}
	mailalias { 'samhain-reports':
		ensure => present,
		recipient => $debianadmin,
		require => Package['debian.org']
	}

	exec { 'apt-get update':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true,
	}

	exec { 'dpkg-reconfigure tzdata -pcritical -fnoninteractive':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true
	}
	exec { 'puppetmaster restart':
		path        => '/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true
	}
	exec { 'rc.local start':
		path        => '/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true
	}
	exec { 'init q':
		refreshonly => true
	}
}
