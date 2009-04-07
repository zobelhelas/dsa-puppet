class sudo {
	package { sudo: ensure => installed }

	file { "/etc/sudoers":
		owner   => root,
		group   => root,
		mode    => 440,
		source  => [ "puppet:///sudo/per-host/$fqdn/sudoers",
		             "puppet:///sudo/common/sudoers" ],
		require => Package["sudo"],
	}
}
