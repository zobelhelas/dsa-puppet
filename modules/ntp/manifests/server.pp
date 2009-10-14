class ntp::server inherits ntp {
	file { "/etc/ntp.conf":
		owner   => root,
		group   => root,
		mode    => 444,
		source  => [ "puppet:///ntp/server.conf" ],
		notify  => Exec["ntp restart"],
		require => Package["ntp"]
		;
		"/var/lib/ntpstats":
		ensure  => directory,
		owner   => ntp,
		group   => ntp,
		mode    => 755
		;
	}
}
