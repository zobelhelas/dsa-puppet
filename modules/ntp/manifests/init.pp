class ntp {
	package { ntp: ensure => installed }
	file { "/var/lib/ntp/":
		ensure  => directory,
		owner   => ntp,
		group   => ntp,
		mode    => 755
		;
	}
	exec { "ntp restart":
		path	    => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
		refreshonly => true,
	}
}
