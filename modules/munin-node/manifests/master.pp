class munin-node::master inherits munin-node {

    package { munin: ensure => installed }

    file {
        "/etc/munin/munin.conf":
            content => template("munin-node/munin.conf.erb"),
            require => Package["munin"];
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
