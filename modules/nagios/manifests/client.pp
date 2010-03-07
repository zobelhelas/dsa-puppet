class nagios::client inherits nagios {
	package {
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
			require => Package["nagios-nrpe-server"],
			ensure  => directory;
		"/etc/nagios/nrpe.d/debianorg.cfg":
                        content => template("nagios/inc-debian.org.erb"),
			require => Package["nagios-nrpe-server"],
			notify  => Exec["nagios-nrpe-server restart"];
		"/etc/nagios/nrpe.d/nrpe_dsa.cfg":
			source  => [ "puppet:///nagios/dsa-nagios/generated/nrpe_dsa.cfg" ],
			require => Package["dsa-nagios-checks"],
			notify  => Exec["nagios-nrpe-server restart"];

		"/etc/nagios/obsolete-packages-ignore":
			source  => [ "puppet:///nagios/per-host/$fqdn/obsolete-packages-ignore",
			             "puppet:///nagios/common/obsolete-packages-ignore" ],
			require => Package["dsa-nagios-checks"];

		"/etc/nagios/obsolete-packages-ignore.d/hostspecific":
                        content => template("nagios/obsolete-packages-ignore.d-hostspecific.erb"),
			require => Package["dsa-nagios-checks"];
	}

	exec { "nagios-nrpe-server restart":
		path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
		refreshonly => true,
	}
        @ferm::rule { "dsa-nagios-v4":
                description     => "Allow nrpe from nagios master",
                rule            => "proto tcp mod state state (NEW) dport (5666) @subchain 'nagios' { saddr (\$HOST_NAGIOS_V4) ACCEPT; }"
        }
        @ferm::rule { "dsa-nagios-v6":
                description     => "Allow nrpe from nagios master",
                domain          => "ip6",
                rule            => "proto tcp mod state state (NEW) dport (5666) @subchain 'nagios' { saddr (\$HOST_NAGIOS_V6) ACCEPT; }"
        }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
