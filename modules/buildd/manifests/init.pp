class buildd {

	# sigh, sort this mess out, kids
	if $::lsbdistcodename in [lenny,squeeze] {
		package { 'schroot': ensure => installed }
	} else {
		package { 'schroot': ensure => held }
	}

	package { 'apt-transport-https':
		ensure => installed,
		stage  => setup,
	}
	package { [
			'sbuild',
			'debootstrap',
			'dupload'
		]:
		ensure => installed
	}

	site::linux_module { 'dm_snapshot': }
	ferm::module { 'nf_conntrack_ftp': }

	site::aptrepo { 'buildd':
		ensure => absent,
	}
	site::aptrepo { 'buildd.debian.org':
		template => 'buildd/etc/apt/sources.list.d/buildd.list.erb',
		key      => 'puppet:///modules/buildd/buildd.debian.org.asc',
		require  => Package['apt-transport-https'],
	}

	file { '/etc/apt/preferences.d/buildd':
		ensure  => absent
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
