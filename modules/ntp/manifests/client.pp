class ntp::client inherits ntp {
	file { "/etc/ntp.conf":
		owner   => root,
		group   => root,
		mode    => 444,
		source  => [ "puppet:///ntp/client.conf" ],
		notify  => Exec["ntp restart"],
		require => Package["ntp"]
		;
	}
}
