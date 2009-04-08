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
    include sudo
    include debian-org

    case $smartarraycontroller {
        "true":    { include debian-proliant }
        default: {}
    }

    case $mta {
        "exim4":   { include exim }
        default:   {}
    }

    import "nagios"
    include nagios-client

    case $hostname {
        spohr:     {
                      import "nagios"
                      include nagios-server
                   }
        default:   {}
    }

    case $apache2 {
        "true":    { case $hostname {
                        "carver":  { include apache2 }
                        default:   {}
                   } }
        default: {}
    }

    case $hostname {
        brahms,goetz,lafayette,malo,praetorius,puccini:
                   { include buildd }
        default:   {}
    }

}

node penalosa inherits default {
    include hosts
}
