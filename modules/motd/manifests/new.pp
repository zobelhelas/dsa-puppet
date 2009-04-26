class motd::new inherits motd {
        $str = $nodeinfo.class
        notice($str)
        notice($nodeinfo)

	file { "/etc/motd.tail":
                notify  => Exec["updatemotd"],
                content => template("motd-new.erb") ;
	}
}
