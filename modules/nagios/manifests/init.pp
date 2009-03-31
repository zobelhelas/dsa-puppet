class nagiosclient {
	package {
		nagios-nrpe-server: ensure => installed;
		dsa-nagios-checks: ensure => installed;
	}

	file {
		"/etc/default/nagios-nrpe-server":
			source  => [ "puppet:///nagios/per-host/$fqdn/default",
			             "puppet:///nagios/common/default" ],
			require => Package["nagios-nrpe-server"],
			notify  => Exec["nagios-nrpe-server restart"];
		"/etc/default/nagios-nrpe":
			ensure  => absent,
			notify  => Exec["nagios-nrpe-server restart"];
		"/etc/nagios/nrpe.cfg":
			source  => [ "puppet:///nagios/per-host/$fqdn/nrpe.cfg",
			             "puppet:///nagios/common/nrpe.cfg" ],
			require => Package["nagios-nrpe-server"],
			notify  => Exec["nagios-nrpe-server restart"];
		"/etc/nagios/nrpe.d":
			mode    => 755,
			ensure  => directory;
		"/etc/nagios/nrpe.d/debianorg.cfg":
			source  => [ "puppet:///nagios/per-host/$fqdn/inc-debian.org",
			             "puppet:///nagios/common/inc-debian.org" ],
			require => Package["nagios-nrpe-server"],
			notify  => Exec["nagios-nrpe-server restart"];
		"/etc/nagios/nrpe.d/nrpe_dsa.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/nrpe_dsa.cfg" ],
			require => Package["nagios-nrpe-server"],
			notify  => Exec["nagios-nrpe-server restart"];
	}

	exec { "nagios-nrpe-server restart":
		path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
		refreshonly => true,
	}
}

