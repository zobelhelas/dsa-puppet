class motd::new inherits motd {
	File ["/etc/motd.tail"] {
                notify  => Exec["updatemotd"],
                content => template("motd-new.erb") ;
	}
}
