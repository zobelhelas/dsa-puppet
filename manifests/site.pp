Package {
    require => File["/etc/apt/apt.conf.d/local-recommends"]
}

File {
    owner   => root,
    group   => root,
    mode    => 444,
    ensure  => file,
}

node default {
    include munin-node
    include samhain
    include debian-org

    case $smartarraycontroller {
        "true":    { include debian-proliant }
        default: {}
    }

    case $mta {
        "exim4":   { include exim }
        default:   {}
    }

    case $hostname {
        spohr,bartok,geo1:
                   {
                      import "nagios"
                      include nagios-client
                   }
        default:   {}
    }


    case $hostname {
        spohr:     {
                      import "nagios"
                      include nagios-server
                   }
        default:   {}
    }
}

node penalosa inherits default {
    include hosts
}
