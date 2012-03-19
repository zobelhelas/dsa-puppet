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
    $nodeinfo  = nodeinfo($::fqdn, "/etc/puppet/modules/debian-org/misc/local.yaml")
    $allnodeinfo = allnodeinfo("sshRSAHostKey ipHostNumber", "purpose mXRecord physicalHost purpose")
    notice( sprintf("hoster for %s is %s", $::fqdn, getfromhash($nodeinfo, 'hoster', 'name') ) )

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

    case $::hostname {
        finzi,fano,fasch,field:    { include kfreebsd }
    }

    if $::smartarraycontroller {
        include debian-proliant
    }

    if $::productname == 'PowerEdge 2850' {
        include megactl
    }

    if $::mptraid {
        include raidmpt
    }

    if $::kvmdomain {
        include acpi
    }

    if $::mta == 'exim4' {
        case getfromhash($nodeinfo, 'heavy_exim') {
             true:  { include exim::mx }
             default: { include exim }
        }
    }

    if getfromhash($nodeinfo, 'puppetmaster') {
        include puppetmaster
    }

    if getfromhash($nodeinfo, 'muninmaster') {
        include munin-node::master
    }

    case getfromhash($nodeinfo, 'nagiosmaster') {
        true:    { include nagios::server }
        default: { include nagios::client }
    }

    if $::apache2 {
         if getfromhash($nodeinfo, 'apache2_security_mirror') {
                include apache2::security_mirror
         }
         if getfromhash($nodeinfo, 'apache2_www_mirror') {
                include apache2::www_mirror
         }
         if getfromhash($nodeinfo, 'apache2_backports_mirror') {
                include apache2::backports_mirror
         }
         if getfromhash($nodeinfo, 'apache2_ftp-upcoming_mirror') {
                include apache2::ftp-upcoming_mirror
         }
         include apache2
    }

    if $::rsyncd {
        include rsyncd-log
    }


    if getfromhash($nodeinfo, 'buildd') {
        include buildd
    }

    case $::hostname {
        ravel,senfl,orff,draghi,diamond: { include named::authoritative }
        geo1,geo2,geo3:                  { include named::geodns }
        liszt:                           { include named::recursor }
    }

    case $::hostname {
        franck,master,lobos,samosa,spohr,widor:   { include unbound }
    }

    if $::lsbdistcodename != 'lenny' {
        include unbound
    }

    include resolv

    if $::kernel == 'Linux' {
        include ferm
        include ferm::per-host
    }

    case $::hostname {
        diabelli,nono,spohr: { include dacs }
    }

    case $::hostname {
        beethoven,duarte,spohr,stabile: {
            include nfs-server
        }
    }

    if $::brokenhosts {
        include hosts
    }

    if $::portforwarder_user_exists {
        include portforwarder
    }

    include samhain

    case $::hostname {
        chopin,geo3,soler,wieck: {
            include debian-radvd
        }
    }

    if $::kernel == 'Linux' {
        include entropykey
    }

    if ($::postgres84 or $::postgres90) {
        include postgres
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
