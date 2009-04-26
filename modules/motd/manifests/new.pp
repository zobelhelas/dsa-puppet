class motdnew inherits motd {
	file { "/etc/motd.tail":
                notify  => Exec["updatemotd"],
                content => template("motd-new.erb") ;
	}
}
