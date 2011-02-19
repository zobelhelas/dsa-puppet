class sysctl {
	package { procps: ensure => installed }

	file { "/etc/sysctl.d/dsa-radvd.conf":
		owner   => root,
		group   => root,
		mode    => 444,
		source  => [ "puppet:///modules/sysctl/per-host/$fqdn/dsa-radvd.conf",
		             "puppet:///modules/sysctl/common/dsa-radvd.conf" ],
		require => Package["procps"]
                ;

	}
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
