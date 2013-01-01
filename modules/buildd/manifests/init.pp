class buildd {

	package { [
			'schroot',
			'sbuild'
		]:
		ensure  => installed,
		require => [
			Exec['apt-get update']
		]
	}

	package { 'apt-transport-https':
		ensure => installed,
	}
	package { [
			'debootstrap',
			'dupload'
		]:
		ensure => installed,
	}

	site::linux_module { 'dm_snapshot': }
	ferm::module { 'nf_conntrack_ftp': }

	site::aptrepo { 'buildd':
		ensure => absent,
	}

	$suite = $::lsbdistcodename ? {
		squeeze => $::lsbdistcodename,
		wheezy  => $::lsbdistcodename,
		undef   => 'squeeze',
		default => 'wheezy'
	}

	if $suite == 'squeeze' {
		site::aptrepo { 'buildd.debian.org':
			key        => 'puppet:///modules/buildd/buildd.debian.org.asc',
			url        => 'https://buildd.debian.org/apt/',
			suite      => $suite,
			components => 'main',
			require    => Package['apt-transport-https'],
			before     => Package[schroot,sbuild]
		}
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
		content => template('buildd/etc/apt/preferences.d/buildd'),
		before  => File['/etc/apt/sources.list.d/buildd.debian.org.list']
	}
	file { '/etc/schroot/mount-defaults':
		content => template('buildd/etc/schroot/mount-defaults.erb'),
		require => Package['sbuild'],
	}
	file { '/etc/cron.d/dsa-buildd':
		source  => 'puppet:///modules/buildd/cron.d-dsa-buildd',
		require => Package['debian.org']
	}
	file { '/etc/dupload.conf':
		source  => 'puppet:///modules/buildd/dupload.conf',
		require => Package['dupload'],
	}
	file { '/etc/default/schroot':
		source  => 'puppet:///modules/buildd/default-schroot',
		require => Package['schroot']
	}

}
