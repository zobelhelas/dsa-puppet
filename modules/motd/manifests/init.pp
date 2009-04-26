class motd {
	file { "/etc/motd.tail":
                notify  => Exec["updatemotd"],
                content => template("motd/motd.erb") ;
	}
        exec { "updatemotd":
                command => "uname -snrvm > /var/run/motd && cat /etc/motd.tail >> /var/run/motd",
                refreshonly => true
        }
}
