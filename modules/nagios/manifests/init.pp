class nagios {
	package {
		nagios-nrpe-server: ensure => installed;
	}
        file {
                "/tmp/test":
                        content => template("nagios/class-test.erb");
        }
}
