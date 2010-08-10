class named::geodns inherits named {
    activate_munin_check {
        "bind_views": script => bind;
    }

    file {
        "/etc/bind/named.conf.options":
            content => template("named/named.conf.options.erb"),
            notify  => Exec["bind9 reload"];
        "/etc/apt/sources.list.d/geoip.list":
            content => template("debian-org/etc/apt/sources.list.d/geoip.list.erb"),
            notify  => Exec["apt-get update"],
            ;
        "/etc/bind/named.conf.local":
            source  => [ "puppet:///named/per-host/$fqdn/named.conf.local",
                         "puppet:///named/common/named.conf.local" ],
            require => Package["bind9"],
            notify  => Exec["bind9 restart"],
            owner   => root,
            group   => root,
            ;
        "/etc/bind/named.conf.acl":
            source  => [ "puppet:///named/per-host/$fqdn/named.conf.acl",
                         "puppet:///named/common/named.conf.acl" ],
            require => Package["bind9"],
            notify  => Exec["bind9 restart"],
            owner   => root,
            group   => root,
            ;
        "/etc/bind/geodns":
            ensure  => directory,
            owner   => root,
            group   => root,
            mode    => 755,
            ;
        "/etc/bind/geodns/zonefiles":
            ensure  => directory,
            owner   => geodnssync,
            group   => geodnssync,
            mode    => 755,
            ;
        "/etc/bind/geodns/named.conf.geo":
            source  => [ "puppet:///named/per-host/$fqdn/named.conf.geo",
                         "puppet:///named/common/named.conf.geo" ],
            require => Package["bind9"],
            notify  => Exec["bind9 restart"],
            owner   => root,
            group   => root,
            ;
        "/etc/bind/geodns/trigger":
            source  => [ "puppet:///named/per-host/$fqdn/trigger",
                         "puppet:///named/common/trigger" ],
            owner   => root,
            group   => root,
            mode    => 555,
            ;
        "/etc/ssh/userkeys/geodnssync":
            source  => [ "puppet:///named/per-host/$fqdn/authorized_keys",
                         "puppet:///named/common/authorized_keys" ],
            owner   => root,
            group   => geodnssync,
            mode    => 440,
            ;
        "/etc/cron.d/dsa-boot-geodnssync":
            source  => [ "puppet:///named/per-host/$fqdn/cron-geo",
                         "puppet:///named/common/cron-geo" ],
            owner   => root,
            group   => root,
            ;
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
