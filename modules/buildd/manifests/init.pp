class buildd ($ensure=present) {

	include schroot

	package { 'sbuild':
		ensure => installed,
		tag    => extra_repo,
	}
	package { 'libsbuild-perl':
		ensure => installed,
		tag    => extra_repo,
		before => Package['sbuild']
	}

	package { 'apt-transport-https':
		ensure => installed,
	}
	if $ensure == present {
		package { 'dupload':
			ensure => installed,
		}
		file { '/etc/dupload.conf':
			source  => 'puppet:///modules/buildd/dupload.conf',
			require => Package['dupload'],
		}
		site::linux_module { 'dm_snapshot': }
		ferm::module { 'nf_conntrack_ftp': }
	}

	site::aptrepo { 'buildd':
		ensure => absent,
	}

	$suite = $::lsbdistcodename ? {
		squeeze => $::lsbdistcodename,
		wheezy  => $::lsbdistcodename,
		undef   => 'squeeze',
		default => 'wheezy'
	}

	site::aptrepo { 'buildd.debian.org':
		key        => 'puppet:///modules/buildd/buildd.debian.org.asc',
		url        => 'https://buildd.debian.org/apt/',
		suite      => $suite,
		components => 'main',
		require    => Package['apt-transport-https'],
	}

	site::aptrepo { 'buildd.debian.org-proposed':
		ensure     => $::hostname ? {
		                             /^(alkman|barber|brahms|porpora|zandonai)$/ => 'present',
		                             default => 'absent',
		                            },
		url        => 'https://buildd.debian.org/apt/',
		suite      => "${suite}-proposed",
		components => 'main',
		require    => Package['apt-transport-https'],
	}

	site::aptrepo { 'buildd.debian.org-experimental':
		ensure     => $::hostname ? {
		                             /^(krenek)$/ => 'present',
		                             default => 'absent',
		                            },
		url        => 'https://buildd.debian.org/apt/',
		suite      => "${suite}-experimental",
		components => 'main',
		require    => Package['apt-transport-https'],
	}

	# 'bad' extension
	file { '/etc/apt/preferences.d/buildd.debian.org':
		ensure => absent,
	}
	file { '/etc/apt/preferences.d/buildd':
		content => template('buildd/etc/apt/preferences.d/buildd'),
		before  => Site::Aptrepo['buildd.debian.org']
	}
	file { '/etc/cron.d/dsa-buildd':
		source  => 'puppet:///modules/buildd/cron.d-dsa-buildd',
		require => Package['debian.org']
	}

	if $::lsbmajdistrelease >= 7 {
		package { 'python-psutil':
			ensure => installed,
		}
		file { '/usr/local/sbin/buildd-schroot-aptitude-kill':
			source  => 'puppet:///modules/buildd/buildd-schroot-aptitude-kill',
			mode    => '0555',
		}
	} else {
		file { '/usr/local/sbin/buildd-schroot-aptitude-kill':
			source  => 'puppet:///modules/buildd/buildd-schroot-aptitude-kill.squeeze',
			mode    => '0555',
		}
	}
	file { '/etc/cron.d/puppet-buildd-aptitude':
		content => "*/5 * * * * root /usr/local/sbin/buildd-schroot-aptitude-kill\n",
	}
}
