Package {
    require => File["/etc/apt/apt.conf.d/local-recommends"]
}

File {
    owner   => root,
    group   => root,
    mode    => 444,
    ensure  => file,
}

Exec {
    path => "/usr/bin:/usr/sbin:/bin:/sbin"
}

node default {
    include munin-node
    include sudo
    include debian-org
    include monit
    include motd

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
        morales:   {}
        default:   { include samhain }
    }

    case $hostname {
        spohr:     {
                      import "nagios"
                      include nagios-server
                   }
        default:   {}
    }

    case $apache2 {
        "true":    { case $hostname {
                        carver,rore,tartini:  { include apache2 }
                        default:   {}
                   } }
        default: {}
    }

    case $hostname {
        ancina,brahms,goedel,goetz,lafayette,malo,praetorius,puccini:
                   { include buildd }
        default:   {}
    }
    case $hostname {
        geo1,geo2,geo3:
                   { include geodns }
        default:   {}
    }
}

node penalosa inherits default {
    include hosts
}
