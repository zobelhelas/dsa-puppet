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
    include apt-keys

    $nodeinfo = nodeinfo($fqdn, "/etc/puppet/modules/debian-org/misc/local.yaml")

    include motd
    include samhain

    case $smartarraycontroller {
        "true":    { include debian-proliant }
        default: {}
    }

    case $mta {
        "exim4":   {
             case extractnodeinfo($nodeinfo, 'heavy_exim') {
                  "true":  { include exim::mx }
                  default: { include exim }
             }
        }
        default:   {}
    }


    case $hostname {
        spohr: {
                      include nagios::server
        }
        default: {
		      include nagios::client
	}
    }

     case extractnodeinfo($nodeinfo, 'apache2_defaultconfig') {
          "true":  { include apache2 }
           default: { }
     }

    case $hostname {
        ancina,arcadelt,argento,brahms,goedel,goetz,lafayette,malo,murphy,praetorius,puccini,paer:
                   { include buildd }
        default:   {}
    }

# maybe wait for rietz to be upgraded to lenny
#    case $hostname {
#        rietz,raff,klecker:
#                   { include named-secondary }
#        default:   {}
#    }

     case $hostname {
         geo1,geo2,geo3:
                    { include geodns }
         default:   {}
     }
}

node penalosa inherits default {
    include hosts
}
