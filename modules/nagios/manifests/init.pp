class nagios-client {
	package {
		nagios-nrpe-server: ensure => installed;
		dsa-nagios-nrpe-config: ensure => purged;
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
			require => Package["dsa-nagios-checks"],
			notify  => Exec["nagios-nrpe-server restart"];
	}

	exec { "nagios-nrpe-server restart":
		path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
		refreshonly => true,
	}
}

class nagios-server {
	package {
		nagios3: ensure => installed;
		nagios-nrpe-plugin: ensure => installed;
		nagios-plugins: ensure => installed;
	}

	file {
		"/etc/nagios-plugins/config/local-dsa-checkcommands.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/static/checkcommands.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];

		"/etc/nagios3/cgi.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/static/cgi.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/nagios.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/static/nagios.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];

		"/etc/nagios3/puppetconf.d":
			mode    => 755,
			ensure  => directory;

		"/etc/nagios3/puppetconf.d/contacts.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/static/conf.d/contacts.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/generic-host.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/static/conf.d/generic-host.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/generic-service.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/static/conf.d/generic-service.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/timeperiods.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/static/conf.d/timeperiods.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];

		"/etc/nagios3/puppetconf.d/auto-dependencies.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/auto-dependencies.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/auto-hostextinfo.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/auto-hostextinfo.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/auto-hostgroups.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/auto-hostgroups.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/auto-hosts.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/auto-hosts.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/auto-serviceextinfo.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/auto-serviceextinfo.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/auto-servicegroups.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/auto-servicegroups.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];
		"/etc/nagios3/puppetconf.d/auto-services.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/auto-services.cfg" ],
			require => Package["nagios3"],
			notify  => Exec["nagios3 reload"];

	}

	exec { "nagios3 reload":
		path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
		refreshonly => true,
	}
}

