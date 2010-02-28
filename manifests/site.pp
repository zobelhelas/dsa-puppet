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
    notice("hoster for ${fqdn} is ${hoster}")

    $mxinfo   = allnodeinfo("mXRecord")

    include munin-node
    include sudo
    include ssh
    include debian-org
    include monit
    include apt-keys
    include ntp

    include motd

    case $hostname {
        finzi,fano,fasch,field:    { include kfreebsd }
    }

    case $smartarraycontroller {
        "true":    { include debian-proliant }
    }
    case $kvmdomain {
        "true":    { package { acpid: ensure => installed } }
    }
    case $mptraid {
        "true":    { include "raid-mpt" }
    }

    case $mta {
        "exim4":   {
             case extractnodeinfo($nodeinfo, 'heavy_exim') {
                  true:    { include exim::mx }
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
                     default: { include apache2 }
              }
         }
    }

    case extractnodeinfo($nodeinfo, 'buildd') {
         true:  { include buildd }
    }

    case $hostname {
        klecker,ravel,senfl,orff: { include named::secondary }
        geo1,geo2,geo3:           { include named::geodns }
        bartok:                   { include named::recursor }
    }

    case $hostname {
        logtest01,geo1,geo2,geo3,bartok: { include ferm }
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
}
