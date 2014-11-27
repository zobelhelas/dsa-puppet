# == Class: debian-org
#
# Stuff common to all debian.org servers
#
class debian-org {
	if getfromhash($site::nodeinfo, 'hoster', 'mirror-debian') {
		$mirror = getfromhash($site::nodeinfo, 'hoster', 'mirror-debian')
	} else {
		$mirror = 'http://http.debian.net/debian/'
	}
	if $::lsbmajdistrelease < 7 {
		$mirror_backports = 'http://backports.debian.org/debian-backports/'
	} else {
		$mirror_backports = $mirror
	}

	$debianadmin = [
		'debian-archive-debian-samhain-reports@master.debian.org',
		'debian-admin@ftbfs.de',
		'weasel@debian.org',
		'steve@lobefin.net',
		'paravoid@debian.org',
		'zumbi@kos.to'
	]

	package { [
			'klogd',
			'sysklogd',
			'rsyslog',
			'os-prober',
			'apt-listchanges',
		]:
		ensure => purged,
	}
	package { [
			'debian.org',
			'dsa-munin-plugins',
		]:
		ensure => installed,
		tag    => extra_repo,
	}
	file { '/etc/ssh/ssh_known_hosts':
		ensure  => present,
		replace => false,
		mode    => '0644',
		source  => 'puppet:///modules/debian-org/basic-ssh_known_hosts'
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

	if $::lsbmajdistrelease == 7 {
		package { 'libfilesystem-ruby1.9.1':
			ensure => installed,
		}
	} elsif $::lsbmajdistrelease >= 8 {
		package { 'ruby-filesystem':
			ensure => installed,
		}
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
			tag    => extra_repo,
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

	file { '/etc/apt/trusted-keys.d':
		ensure => absent,
		force  => true,
	}

	file { '/etc/apt/trusted.gpg':
		mode    => '0600',
		content => "",
	}

	site::aptrepo { 'security':
		url        => 'http://security.debian.org/',
		suite      => "${::lsbdistcodename}/updates",
		components => ['main','contrib','non-free']
	}
	if $::lsbmajdistrelease < 7 {
		site::aptrepo { 'debian-lts':
			url        => $mirror,
			suite      => "${::lsbdistcodename}-lts",
			components => ['main','contrib','non-free']
		}
	} else {
		site::aptrepo { 'debian-lts':
			ensure => absent,
		}
	}

	site::aptrepo { 'backports.debian.org':
		url        => $mirror_backports,
		suite      => "${::lsbdistcodename}-backports",
		components => ['main','contrib','non-free']
	}

	site::aptrepo { 'volatile':
		url        => $mirror,
		suite      => "${::lsbdistcodename}-updates",
		components => ['main','contrib','non-free']
	}

	#if ($::hostname in [ball, corelli, eysler, lucatelli, mayer, mayr, pettersson]) or
	#   ($::hoster and ($::hoster in [bytemark, man-da, brown])) {
	#	site::aptrepo { 'proposed-updates':
	#		url        => $mirror,
	#		suite      => "${::lsbdistcodename}-proposed-updates",
	#		components => ['main','contrib','non-free']
	#	}
	#} else {
		site::aptrepo { 'proposed-updates':
			ensure => absent,
		}
	#}

	site::aptrepo { 'debian.org':
		ensure => absent,
	}

	site::aptrepo { 'db.debian.org':
		url        => 'http://db.debian.org/debian-admin',
		suite      => 'debian-all',
		components => 'main',
		key        => 'puppet:///modules/debian-org/db.debian.org.gpg',
	}
	site::aptrepo { 'db.debian.org-suite':
		url        => 'http://db.debian.org/debian-admin',
		suite      => $::lsbdistcodename,
		components => 'main',
	}

	augeas { 'inittab_replicate':
		context => '/files/etc/inittab',
		changes => [
			'set ud/runlevels 2345',
			'set ud/action respawn',
			'set ud/process "/usr/bin/ud-replicated -d"',
		],
		notify  => Exec['init q'],
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
	file { '/etc/systemd/system':
		ensure  => directory,
		recurse => true,
	}
        file { '/etc/systemd/system/puppet.service':
		ensure => 'link',
		target => '/dev/null',
		notify => Exec['systemctl daemon-reload'],
	}

	file { '/etc/cron.d/dsa-puppet-stuff':
		source  => 'puppet:///modules/debian-org/dsa-puppet-stuff.cron',
		require => Package['debian.org'],
	}
	file { '/etc/ldap/ldap.conf':
		require => Package['debian.org'],
		source  => 'puppet:///modules/debian-org/ldap.conf',
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
		notify => Exec['service rc.local start'],
	}
	file { '/etc/dsa':
		ensure => directory,
		mode   => '0755',
	}
	file { '/etc/dsa/cron.ignore.dsa-puppet-stuff':
		source  => 'puppet:///modules/debian-org/dsa-puppet-stuff.cron.ignore',
		require => Package['debian.org']
	}
	file { '/etc/nsswitch.conf':
		mode   => '0755',
		source => 'puppet:///modules/debian-org/nsswitch.conf',
	}

	# set mmap_min_addr to 4096 to mitigate
	# Linux NULL-pointer dereference exploits
	site::sysctl { 'mmap_min_addr':
		ensure => absent
	}
	site::sysctl { 'perf_event_paranoid':
		key   => 'kernel.perf_event_paranoid',
		value => '2',
	}
	site::alternative { 'editor':
		linkto => '/usr/bin/vim.basic',
	}
	site::alternative { 'view':
		linkto => '/usr/bin/vim.basic',
	}
	mailalias { 'samhain-reports':
		ensure    => present,
		recipient => $debianadmin,
		require   => Package['debian.org']
	}

	file { '/usr/local/bin/check_for_updates':
		source => 'puppet:///modules/debian-org/check_for_updates',
		mode   => '0755',
		owner  => root,
		group  => root,
	}

	exec { 'apt-get update':
		path    => '/usr/bin:/usr/sbin:/bin:/sbin',
		onlyif  => '/usr/local/bin/check_for_updates',
		require => File['/usr/local/bin/check_for_updates']
	}
	Exec['apt-get update']->Package<| tag == extra_repo |>

	exec { 'dpkg-reconfigure tzdata -pcritical -fnoninteractive':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true
	}
	exec { 'service puppetmaster restart':
		refreshonly => true
	}
	exec { 'service rc.local start':
		refreshonly => true
	}
	exec { 'init q':
		refreshonly => true
	}

	exec { 'systemctl daemon-reload':
		refreshonly => true,
		onlyif  => "test -x /bin/systemctl"
	}

	tidy { '/var/lib/puppet/clientbucket/':
		age      => '2w',
		recurse  => 9,
		type     => ctime,
		matches  => [ 'paths', 'contents' ],
		schedule => weekly
	}

	file { '/root/.bashrc':
		source => 'puppet:///modules/debian-org/root-dotfiles/bashrc',
	}
	file { '/root/.profile':
		source => 'puppet:///modules/debian-org/root-dotfiles/profile',
	}
	file { '/root/.screenrc':
		source => 'puppet:///modules/debian-org/root-dotfiles/screenrc',
	}
	file { '/root/.vimrc':
		source => 'puppet:///modules/debian-org/root-dotfiles/vimrc',
	}
}
