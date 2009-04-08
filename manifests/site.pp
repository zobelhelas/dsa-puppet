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

    # test here first
    case $hostname {
        handel,geo1,geo2,geo3,wieck,brahms,bartok,spohr,sperger,carver,rore,malo,peri,penalosa,praetorius,schein,villa,lobos,steffani,kassia,pergolesi,lafayette,rem,albeniz,goetz,smetana,allegri,puccini,ball,argento,arcadelt,dijkstra,schumann,caballero,voltaire,pescetti,mundy,agricola,goedel,lebrun,mayer,mayr,merulo,morales,murphy,paer,saens,schroeder,spontini,widor,zelenka,agnesi,piatti,powell,samosa,gluck,rietz,unger,tartini,mahler,raff,chopin:    { include sudo }
        default:   {}
    }
}

node penalosa inherits default {
    include hosts
}
