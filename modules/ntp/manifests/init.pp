class ntp {
	package { ntp: ensure => installed }
	file {	"/var/lib/ntp/":
			ensure  => directory,
			owner   => ntp,
			group   => ntp,
			mode    => 755
			;
		"/var/lib/ntpstats":
			ensure  => directory,
			owner   => ntp,
			group   => ntp,
			mode    => 755
			;
		"/etc/ntp.conf":
			owner   => root,
			group   => root,
			mode    => 444,
			content => template("ntp/ntp.conf"),
			notify  => Exec["ntp restart"],
			require => Package["ntp"]
			;
	}
	exec { "ntp restart":
		path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
		refreshonly => true,
	}
        @ferm::rule { "dsa-ntp":
                domain          => "(ip ip6)",
                description     => "Allow ntp access",
                rule            => "&SERVICE(udp, 123)"
        }
}
