class nagios {
	package {
		nagios-nrpe-server: ensure => installed;
	}
	ferm::rule { "dsa-nagios":
		description     => "Allow nrpe from spohr.debian.org",
		rule            => "proto tcp dport 5666 saddr $HOST_NAGIOS ACCEPT"
		prio		=> "03"
	}
}
