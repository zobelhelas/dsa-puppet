class motd {
	file { "/etc/motd":
                content => template("motd.erb") ;
	}
}
