class named::secondary inherits named {
    file { "/etc/bind/named.conf.options":
        content => template("named/named.conf.options.erb"),
        notify  => Exec["bind9 reload"],
    }
}


