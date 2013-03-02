class buildd ($ensure=present) {

	$package_ensure = $ensure ? {
		present => installed,
		absent  => $ensure
	}

	package { 'schroot':
		ensure => $package_ensure,
		tag    => extra_repo,
	}
	package { 'sbuild':
		ensure => $package_ensure,
		tag    => extra_repo,
	}
	package { 'libsbuild-perl':
		ensure => $package_ensure,
		tag    => extra_repo,
		before => Package['sbuild']
	}

	package { 'apt-transport-https':
		ensure => $package_ensure,
	}
	package { [
			'debootstrap',
			'dupload'
		]:
		ensure => installed,
	}

	site::linux_module { 'dm_snapshot':
		ensure => $ensure
	}
	ferm::module { 'nf_conntrack_ftp':
		ensure => $ensure
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
		ensure     => $ensure,
		key        => 'puppet:///modules/buildd/buildd.debian.org.asc',
		url        => 'https://buildd.debian.org/apt/',
		suite      => $suite,
		components => 'main',
		require    => Package['apt-transport-https'],
	}

	if $::hostname in [alkman,porpora,zandonai] {
		site::aptrepo { 'buildd.debian.org-proposed':
			url        => 'https://buildd.debian.org/apt/',
			suite      => "${suite}-proposed",
			components => 'main',
			require    => Package['apt-transport-https'],
		}
	}

	if $::hostname in [krenek] {
		site::aptrepo { 'buildd.debian.org-experimental':
			url        => 'https://buildd.debian.org/apt/',
			suite      => "${suite}-experimental",
			components => 'main',
			require    => Package['apt-transport-https'],
		}
	}

	# 'bad' extension
	file { '/etc/apt/preferences.d/buildd.debian.org':
		ensure => absent,
	}
	file { '/etc/apt/preferences.d/buildd':
		ensure  => $ensure,
		content => template('buildd/etc/apt/preferences.d/buildd'),
		before  => Site::Aptrepo['buildd.debian.org']
	}
	file { '/etc/schroot/mount-defaults':
		ensure  => $ensure,
		content => template('buildd/etc/schroot/mount-defaults.erb'),
		require => Package['sbuild'],
	}
	file { '/etc/cron.d/dsa-buildd':
		ensure  => $ensure,
		source  => 'puppet:///modules/buildd/cron.d-dsa-buildd',
		require => Package['debian.org']
	}
	file { '/etc/dupload.conf':
		ensure  => $ensure,
		source  => 'puppet:///modules/buildd/dupload.conf',
		require => Package['dupload'],
	}
	file { '/etc/default/schroot':
		ensure  => $ensure,
		source  => 'puppet:///modules/buildd/default-schroot',
		require => Package['schroot']
	}
}
