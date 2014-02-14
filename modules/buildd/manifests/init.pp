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
		include ferm::ftp_conntrack
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

	$buildd_prop_ensure = $::hostname ? {
		/^(alkman|barber|brahms|porpora|zandonai)$/ => 'present',
		default => 'absent',
	}

	file { '/etc/apt/apt.conf.d/puppet-https-buildd':
		content => "Acquire::https::buildd.debian.org::CaInfo \"/etc/ssl/certs/buildd.debian.org.crt\";\n",
		#require => File['/etc/ssl/certs/buildd.debian.org.crt']
	}
	site::aptrepo { 'buildd.debian.org-proposed':
		ensure     => $buildd_prop_ensure,
		url        => 'https://buildd.debian.org/apt/',
		suite      => "${suite}-proposed",
		components => 'main',
		require    => [ Package['apt-transport-https'],
		                File['/etc/apt/apt.conf.d/puppet-https-buildd'] ],
	}

	# 'bad' extension
	file { '/etc/apt/preferences.d/buildd.debian.org':
		ensure => absent,
	}
	file { '/etc/apt/preferences.d/buildd':
		ensure => absent,
	}
	file { '/etc/cron.d/dsa-buildd':
		source  => 'puppet:///modules/buildd/cron.d-dsa-buildd',
		require => Package['debian.org']
	}

	if ($::lsbmajdistrelease >= 7 and $::kernel == 'Linux') {
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
