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
    $allnodeinfo = allnodeinfo("sshRSAHostKey ipHostNumber", "purpose mXRecord physicalHost purpose")
    notice( sprintf("hoster for %s is %s", $fqdn, getfromhash($nodeinfo, 'hoster', 'name') ) )

    include munin-node
    include syslog-ng
    include sudo
    include ssh
    include debian-org
    include monit
    include apt-keys
    include ntp
    include ntpdate
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
            case $debarchitecture {
                kfreebsd-amd64,kfreebsd-i386: {
                }
                default: {
                    package { acpid: ensure => installed }
                    case $lsbdistcodename {
                        'lenny':    { }
                        default:    { package { acpi-support-base: ensure => installed } }
                    }
                }
            }
        }
    }
    case $mptraid {
        "true":    { include "raidmpt" }
    }
    case $productname {
        "PowerEdge 2850": { include megactl }
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
              case getfromhash($nodeinfo, 'apache2_backports_mirror') {
                     true:    { include apache2::backports_mirror }
              }
              case getfromhash($nodeinfo, 'apache2_ftp-upcoming_mirror') {
                     true:    { include apache2::ftp-upcoming_mirror }
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
        ravel,senfl,orff,draghi,diamond: { include named::authoritative }
        geo1,geo2,geo3:                          { include named::geodns }
        liszt:                                   { include named::recursor }
    }
    case $hostname {
        franck,master,lobos,samosa,spohr,widor:   { include unbound }
    }
    case $lsbdistcodename {
        'lenny':    { }
        default:    { include unbound }
    }
    include resolv

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
        diabelli,rossini,spohr: { include dacs }
    }

    case $hostname {
        beethoven,duarte,spohr,stabile: {
            include nfs-server
        }
    }

    case $brokenhosts {
        "true":    { include hosts }
    }
    case $portforwarder_user_exists {
        "true":    { include portforwarder }
    }

    include samhain

    case $hostname {
        byrd,schuetz,tchaikovsky,draghi,quantz,lamb,locke,rautavaara,rietz: {
            include krb
        }
    }

    case $hostname {
        chopin,geo3,soler,wieck: {
            include debian-radvd
        }
    }

    case $kernel {
        Linux: { include entropykey }
    }
    if $::postgres84 == "true" {
        include postgres
    } elsif $::postgres90 == "true" {
        include postgres
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
