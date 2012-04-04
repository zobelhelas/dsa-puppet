class debian-org {

	$debianadmin = [
		'debian-archive-debian-samhain-reports@master.debian.org',
		'debian-admin@ftbfs.de',
		'weasel@debian.org',
		'steve@lobefin.net',
		'paravoid@debian.org'
	]

	package { [
			'apt-utils',
			'bash-completion',
			'debian.org',
			'dnsutils',
			'dsa-munin-plugins',
			'klogd',
			'less',
			'lsb-release',
			'libfilesystem-ruby1.8',
			'molly-guard',
			'mtr-tiny',
			'nload',
			'pciutils',
			'rsyslog',
			'sysklogd',
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
			ensure => installed
		}
	}

	# This really means 'not wheezy'

	if $::debarchitecture != 'armhf' {
		site::aptrepo { 'security':
			template => 'debian-org/etc/apt/sources.list.d/security.list.erb',
		}
		site::aptrepo { 'backports.org':
			template => 'debian-org/etc/apt/sources.list.d/backports.org.list.erb',
			key      => 'puppet:///modules/debian-org/backports.org.asc',
		}
		site::aptrepo { 'volatile':
			template => 'debian-org/etc/apt/sources.list.d/volatile.list.erb',
		}
	}

	site::aptrepo { 'debian.org':
		template => 'debian-org/etc/apt/sources.list.d/debian.org.list.erb',
		key      => 'puppet:///modules/debian-org/db.debian.org.asc',
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
	file { '/etc/puppet/puppet.conf':
		source => 'puppet:///modules/debian-org/puppet.conf',
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
	file { '/etc/rc.local':
		mode   => '0755',
		source => 'puppet:///modules/debian-org/rc.local',
		notify => Exec['rc.local start'],
	}
	file { '/etc/molly-guard/run.d/15-acquire-reboot-lock':
		mode    => '0755',
		source  => 'puppet:///modules/debian-org/molly-guard-acquire-reboot-lock',
		require => Package['molly-guard'],
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
	mailalias { 'samhain-reports':
		ensure => present,
		recipient => $debianadmin,
	}

	exec { 'apt-get update':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true,
	}-> Package <| |>

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
