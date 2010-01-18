class munin-node::master inherits munin-node {

    package { munin: ensure => installed }

    file {
        "/etc/munin/munin.conf":
            content => template("munin-node/munin.conf.erb"),
            require => Package["munin"];
    }
}

