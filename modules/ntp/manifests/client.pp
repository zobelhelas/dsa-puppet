class ntp::client inherits ntp {
	file { "/etc/ntp.conf":
		owner   => root,
		group   => root,
		mode    => 444,
		source  => [ "puppet:///ntp/per-host/$fqdn/client.conf",
		             "puppet:///ntp/common/client.conf" ],
		notify  => Exec["ntp restart"],
		require => Package["ntp"]
		;
	}
}
