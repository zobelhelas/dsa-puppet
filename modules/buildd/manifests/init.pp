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
		key        => 'puppet:///modules/buildd/buildd.debian.org.gpg',
		url        => 'https://buildd.debian.org/apt/',
		suite      => $suite,
		components => 'main',
		require    => Package['apt-transport-https'],
	}

	$buildd_prop_ensure = $::hostname ? {
		/^(alkman|brahms|porpora|zandonai)$/ => 'present',
		default => 'absent',
	}

	if ($::lsbmajdistrelease >= 8) {
		file { '/etc/apt/apt.conf.d/puppet-https-buildd':
			content => "Acquire::https::buildd.debian.org::CaInfo \"/etc/ssl/ca-debian/ca-certificates.crt\";\n",
		}
	} else {
		file { '/etc/apt/apt.conf.d/puppet-https-buildd':
			content => "Acquire::https::buildd.debian.org::CaInfo \"/etc/ssl/servicecerts/buildd.debian.org.crt\";\n",
		}
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
		if ($::lsbmajdistrelease >= 8) {
			file { '/usr/local/sbin/buildd-schroot-aptitude-kill':
				source  => 'puppet:///modules/buildd/buildd-schroot-aptitude-kill',
				mode    => '0555',
			}
		} else {
			file { '/usr/local/sbin/buildd-schroot-aptitude-kill':
				source  => 'puppet:///modules/buildd/buildd-schroot-aptitude-kill.wheezy',
				mode    => '0555',
			}
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

	if $has_srv_buildd {
		file { '/etc/cron.d/puppet-update-buildd-schroots':
			content  => "13 21 * * 0 root PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin setup-all-dchroots buildd\n",
		}
	}

	file { '/home/buildd':
		ensure  => directory,
		mode    => '2755',
		group   => buildd,
		owner   => buildd,
	}
	file { '/home/buildd/build':
		ensure  => directory,
		mode    => '2750',
		group   => buildd,
		owner   => buildd,
	}
	file { '/home/buildd/logs':
		ensure  => directory,
		mode    => '2750',
		group   => buildd,
		owner   => buildd,
	}
	file { '/home/buildd/old-logs':
		ensure  => directory,
		mode    => '2750',
		group   => buildd,
		owner   => buildd,
	}
	file { '/home/buildd/upload-security':
		ensure  => directory,
		mode    => '2750',
		group   => buildd,
		owner   => buildd,
	}
	file { '/home/buildd/stats':
		ensure  => directory,
		mode    => '2755',
		group   => buildd,
		owner   => buildd,
	}
	file { '/home/buildd/stats/graphs':
		ensure  => directory,
		mode    => '2755',
		group   => buildd,
		owner   => buildd,
	}
	file { '/home/buildd/upload':
		ensure  => directory,
		mode    => '2755',
		group   => buildd,
		owner   => buildd,
	}
	file { '/home/buildd/.forward':
		content  => "|/usr/bin/buildd-mail\n",
		group   => buildd,
		owner   => buildd,
	}

	if ! $::buildd_key {
		exec { 'create-buildd-key':
			command => '/bin/su - buildd -c \'mkdir -p -m 02700 .ssh && ssh-keygen -C "`whoami`@`hostname` (`date +%Y-%m-%d`)" -P "" -f .ssh/id_rsa -q\'',
			onlyif  => '/usr/bin/getent passwd buildd > /dev/null && ! [ -e /home/buildd/.ssh/id_rsa ]'
		}
	}


	if $::buildd_user_exists {
		exec { 'add-buildd-user-to-sbuild':
			command => 'adduser buildd sbuild',
			onlyif  => "getent group sbuild > /dev/null && ! getent group sbuild | grep '\\<buildd\\>' > /dev/null"
		}
	}
}
