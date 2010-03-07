class motd {
	file { "/etc/motd.tail":
                notify  => Exec["updatemotd"],
                content => template("motd/motd.erb") ;
               "/etc/motd":
                 ensure => "/var/run/motd";
	}
        exec { "updatemotd":
                command => "uname -snrvm > /var/run/motd && cat /etc/motd.tail >> /var/run/motd",
                refreshonly => true
        }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
