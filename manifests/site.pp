Package {
	require => File['/etc/apt/apt.conf.d/local-recommends']
}

File {
	owner  => root,
	group  => root,
	mode   => '0444',
	ensure => file,
}

Exec {
	path => '/usr/bin:/usr/sbin:/bin:/sbin'
}

Service {
	hasrestart => true,
	hasstatus  => true,
}

node default {
	include site
	include munin
	include syslog-ng
	include sudo
	include ssh
	include debian-org
	include monit
	include ntp
	include ntpdate
	include ssl
	include hardware
	include nagios::client
	include resolv
	include roles
	include motd
	include unbound
	include bacula::client
	include autofs
	include lvm
	include multipath
	if $::lsbdistcodename == squeeze {
		include roles::udldap::client
	} else {
		include roles::pubsub::client
		class { 'roles::udldap::client':
			ensure => absent
		}
	}

	if $::hostname in [ubc-bl7,ubc-bl3,ubc-bl2,ubc-bl6,ubc-bl8,luchesi,byrd,clementi,czerny,bm-bl1,bm-bl2,bm-bl3,bm-bl4,bm-bl5,bm-bl6,bm-bl7,bm-bl8,csail-node01,csail-node02,grnet-node01,grnet-node02] {
		include ganeti2
	}

	if $::hostname == 'dinis' {
		include bacula::director
	} else {
		package { 'bacula-console':
			ensure => purged;
		}

		file { '/etc/bacula/bconsole.conf':
			ensure => absent;
		}
	}

	if $::hostname == 'storace' {
		include bacula::storage
	}

	if $::kernel == Linux {
		include linux
		if $::kvmdomain {
			include acpi
		}
	} elsif $::kernel == 'GNU/kFreeBSD' {
		include kfreebsd
	}

	if $::mta == 'exim4' {
		if getfromhash($site::nodeinfo, 'heavy_exim') {
			include exim::mx
		} else {
			include exim
		}
	} elsif $::mta == 'postfix' {
		include postfix
	} else {
		include exim
	}

	if $::apache2 {
		include apache2
	}

	if $::hostname in [geo1,geo2,geo3] {
		include named::geodns
	}

	#if $::hostname in [diabelli,nono,tchaikovsky] {
	#	include dacs
	#}

	if $::hostname in [beach,glinka,milanollo,lw01,lw02,lw03,lw04] {
		include nfs-server
	}

	if $::brokenhosts {
		include hosts
	}

	if $::portforwarder_user_exists {
		include portforwarder
	}

	if $::samhain {
		include samhain
	}

	if $::hostname in [chopin,geo3,soler,wieck] {
		include debian-org::radvd
	}

	if ($::postgres) {
		include postgres
	}

	if $::spamd {
		munin::check { 'spamassassin': }
	}

	if $::hoster {
		if $::hoster in [ynic] {
			include lldp
		}
	}
}
