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
    $localinfo = yamlinfo('*', "/etc/puppet/modules/debian-org/misc/local.yaml")
    $nodeinfo  = nodeinfo($fqdn, "/etc/puppet/modules/debian-org/misc/local.yaml")
    $hosterinfo = whohosts($nodeinfo, "/etc/puppet/modules/debian-org/misc/hoster.yaml")
    $keyinfo   = allnodeinfo("sshRSAHostKey", "ipHostNumber", "purpose")
    $mxinfo    = allnodeinfo("mXRecord")
    notice("hoster for ${fqdn} is ${hosterinfo}")

    include munin-node
    include syslog-ng
    include sudo
    include ssh
    include debian-org
    include monit
    include apt-keys
    include ntp
    include ssl

    include motd

    case $hostname {
        finzi,fano,fasch,field:    { include kfreebsd }
    }

    case $smartarraycontroller {
        "true":    { include debian-proliant }
    }
    case $kvmdomain {
        "true": {
            package { acpid: ensure => installed }
            case getfromhash($nodeinfo, 'squeeze') {
                true:  { package { acpi-support-base: ensure => installed } }
            }
        }
    }
    case $mptraid {
        "true":    { include "raidmpt" }
    }

    case $mta {
        "exim4":   {
             case getfromhash($nodeinfo, 'heavy_exim') {
                  true:  { include exim::mx }
                  default: { include exim }
             }
        }
    }

    case getfromhash($nodeinfo, 'puppetmaster') {
        true: { include puppetmaster }
    }

    case getfromhash($nodeinfo, 'muninmaster') {
        true: { include munin-node::master }
    }

    case getfromhash($nodeinfo, 'nagiosmaster') {
        true:    { include nagios::server }
        default: { include nagios::client }
    }

    case $apache2 {
         "true":  {
              case getfromhash($nodeinfo, 'apache2_security_mirror') {
                     true:    { include apache2::security_mirror }
              }
              case getfromhash($nodeinfo, 'apache2_www_mirror') {
                     true:    { include apache2::www_mirror }
              }
              include apache2
         }
    }

    case $rsyncd {
         "true": { include rsyncd-log }
    }


    case getfromhash($nodeinfo, 'buildd') {
         true:  {
             include buildd
         }
    }

    case $hostname {
        klecker,ravel,senfl,orff,draghi: { include named::authoritative }
        geo1,geo2,geo3:                  { include named::geodns }
        franck,liszt,master,samosa,schein,spohr,steffani,widor:   { include named::recursor }
    }

    case $kernel {
        Linux: {
            include ferm
            include ferm::per-host
            case $rsyncd {
                "true": { include ferm::rsync }
            }
        }
    }

    case $hostname {
        beethoven,ravel,spohr,stabile: {
            include nfs-server
        }
    }

    case $brokenhosts {
        "true":    { include hosts }
    }
    case getfromhash($hosterinfo, 'nameservers') {
        false:      {}
        default:    { include resolv }
    }
    case $portforwarder_user_exists {
        "true":    { include portforwarder }
    }

    include samhain

    case $hostname {
        byrd,schuetz,tchaikovsky: {
            include krb
        }
        draghi,quantz: {
            include krb
            include afs
        }
        lamb,locke,rautavaara,rietz: {
            include krb
            include afs::server
        }
    }

    case $hostname {
        chopin,geo3,soler,wieck: {
            include debian-radvd
        }
   }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
