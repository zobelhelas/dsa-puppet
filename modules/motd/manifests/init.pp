class motd {
	file { "/etc/motd.tail":
                notify  => Exec["updatemotd"],
                content => template("motd.erb") ;
	}
        exec { "updatemotd":
                command => "/bin/uname -snrvm > /var/run/motd && /bin/cat /etc/motd.tail >> /var/run/motd"
        }
}
