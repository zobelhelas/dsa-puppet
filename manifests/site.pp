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
    $hoster    = whohosts($nodeinfo, "/etc/puppet/modules/debian-org/misc/hoster.yaml")
    $keyinfo   = allnodeinfo("sshRSAHostKey", "ipHostNumber")
    $mxinfo    = allnodeinfo("mXRecord")
    notice("hoster for ${fqdn} is ${hoster}")

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
            case extractnodeinfo($nodeinfo, 'squeeze') {
                'true':  { package { acpi-support-base: ensure => installed } }
            }
        }
    }
    case $mptraid {
        "true":    { include "raidmpt" }
    }

    case $mta {
        "exim4":   {
             case extractnodeinfo($nodeinfo, 'heavy_exim') {
                  'true':  { include exim::mx }
                  default: { include exim }
             }
        }
    }

    case extractnodeinfo($nodeinfo, 'muninmaster') {
        true: { include munin-node::master }
    }

    case extractnodeinfo($nodeinfo, 'nagiosmaster') {
        true:    { include nagios::server }
        default: { include nagios::client }
    }

    case $apache2 {
         "true":  {
              case extractnodeinfo($nodeinfo, 'apache2_security_mirror') {
                     true:    { include apache2::security_mirror }
              }
              case extractnodeinfo($nodeinfo, 'apache2_www_mirror') {
                     true:    { include apache2::www_mirror }
              }
              default: { include apache2 }
         }
    }

    case $rsyncd {
         "true": { include rsyncd-log }
    }


    case extractnodeinfo($nodeinfo, 'buildd') {
         'true':  {
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
    case $hoster {
        "ubcece", "darmstadt", "ftcollins", "grnet":  { include resolv }
    }
    case $portforwarder_user_exists {
        "true":    { include portforwarder }
    }

    include samhain

    case $hostname {
        byrd,schuetz,tchaikovsky: {
            include krb
        }
        draghi,quantz,samosa: {
            include krb
            include afs
        }
        lamb,locke,rautavaara,rietz: {
            include krb
            include afs::server
        }
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
