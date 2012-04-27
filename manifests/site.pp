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
	include motd
	include hardware
	include nagios::client
	include resolv
	include roles

	if $::hostname in [pasquini,tristano] {
		include ganeti2
	}

	if $::kernel == Linux {
		include linux
	} elsif $::kernel == 'GNU/kFreeBSD' {
		include kfreebsd
	}

	if $::kvmdomain {
		include acpi
	}

	if $::mta == 'exim4' {
		if getfromhash($site::nodeinfo, 'heavy_exim') {
			include exim::mx
		} else {
			include exim
		}
	} else {
		include postfix
	}

	if $::lsbdistcodename != 'lenny' {
		include unbound
	}

	if $::apache2 {
		include apache2
	}

	if $::rsyncd {
		include rsyncd-log
	}

	if $::hostname in [ravel,senfl,orff,draghi,diamond] {
		include named::authoritative
	} elsif $::hostname in [geo1,geo2,geo3] {
		include named::geodns
	} elsif $::hostname == 'liszt' {
		include named::recursor
	}

	if $::hostname in [diabelli,nono,spohr] {
		include dacs
	}

	if $::hostname in [beethoven,duarte,spohr,stabile] {
		include nfs-server
	}

	if $::brokenhosts {
		include hosts
	}

	if $::portforwarder_user_exists {
		include portforwarder
	}

	include samhain

	if $::hostname in [chopin,geo3,soler,wieck] {
		include debian-org::radvd
	}

	if ($::postgres84 or $::postgres90) {
		include postgres
	}

	if $::spamd {
		munin::check { 'spamassassin': }
	}

	if $::hostname in [chopin,franck,ravel] {
		include vsftpd
	}
}
