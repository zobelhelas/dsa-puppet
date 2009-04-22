class motd {
	file { "/etc/motd.tail":
                content => template("motd.erb") ;
	}
}
