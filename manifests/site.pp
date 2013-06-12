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

	if $::hostname in [pasquini,tristano,bertali,boito,rossini,salieri,dijkstra,luchesi,byrd,clementi,czerny,bm-bl1,bm-bl2,bm-bl3,bm-bl4,bm-bl5,bm-bl6,bm-bl7,bm-bl8,bm-bl9,bm-bl10,bm-bl11,bm-bl12,bm-bl13,bm-bl14] {
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

	if $::hostname == 'beethoven' {
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

	if $::hostname in [ravel,senfl,orff,draghi,diamond,rietz] {
		include named::authoritative
	} elsif $::hostname in [geo1,geo2,geo3] {
		include named::geodns
	}
	if $::hostname in [orff] {
		include dnsextras::entries
	}

	if $::hostname in [diabelli,nono,spohr] {
		include dacs
	}

	if $::hostname in [beethoven,spohr,stabile,beach,glinka,milanollo,rautavaara] {
		include nfs-server
	}

	if $::hostname == 'vieuxtemps' {
		include varnish
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
