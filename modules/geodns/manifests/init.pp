class geodns {

    package { bind9: ensure => installed }

    file {
      "/etc/apt/sources.list.d/geoip.list":
             source => "puppet:///files/etc/apt/sources.list.d/geoip.list",
             notify  => Exec["apt-get update"],
             ;
    }
    file { "/etc/bind/named.conf.local":
        source  => [ "puppet:///geodns/per-host/$fqdn/named.conf.local",
                     "puppet:///geodns/common/named.conf.local" ],
        require => Package["bind9"],
        notify  => Exec["bind9 restart"],
        owner   => root,
        group   => root,

    }
    file { "/etc/bind/named.conf.geo":
        source  => [ "puppet:///geodns/per-host/$fqdn/named.conf.geo",
                     "puppet:///geodns/common/named.conf.geo" ],
        require => Package["bind9"],
        notify  => Exec["bind9 restart"],
        owner   => root,
        group   => root,

    }
    file { "/etc/bind/named.conf.acl":
        source  => [ "puppet:///geodns/per-host/$fqdn/named.conf.acl",
                     "puppet:///geodns/common/named.conf.acl" ],
        require => Package["bind9"],
        notify  => Exec["bind9 restart"],
        owner   => root,
        group   => root,

    }
    file { "/etc/bind/named.conf.options":
        source  => [ "puppet:///geodns/per-host/$fqdn/named.conf.options",
                     "puppet:///geodns/common/named.conf.options" ],
        require => Package["bind9"],
        notify  => Exec["bind9 restart"],
        owner   => root,
        group   => root,

    }

    exec { "bind9 restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

