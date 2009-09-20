class nagios::server inherits nagios::client {
	package {
		nagios3: ensure => installed;
		nagios-nrpe-plugin: ensure => installed;
		nagios-plugins: ensure => installed;
		nagios-images: ensure => installed;
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
			require => Package["nagios3"],
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
