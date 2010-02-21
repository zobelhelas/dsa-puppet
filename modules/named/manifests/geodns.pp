class named::geodns inherits named {
        activate_munin_check {
                "bind_views": script => bind;
        }

        file {
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
                "/etc/bind/named.conf.options":
                        content => template("named/named.conf.options.erb"),
                        require => Package["bind9"],
                        notify  => Exec["bind9 restart"],
                        owner   => root,
                        group   => root,
                        ;

                "/etc/bind/geodns":
                        ensure  => directory,
                        owner   => root,
                        group   => geodnssync,
                        mode    => 775,
                        ;
                "/etc/bind/geodns/named.conf.geo":
                        source  => [ "puppet:///named/per-host/$fqdn/named.conf.geo",
                                     "puppet:///named/common/named.conf.geo" ],
                        require => Package["bind9"],
                        notify  => Exec["bind9 restart"],
                        owner   => root,
                        group   => root,
                        ;
                "/etc/bind/geodns/recvconf":
                        source  => [ "puppet:///named/per-host/$fqdn/recvconf",
                                     "puppet:///named/common/recvconf" ],
                        owner   => root,
                        group   => root,
                        mode    => 555,
                        ;
                "/etc/bind/geodns/recvconf.files":
                        source  => [ "puppet:///named/per-host/$fqdn/recvconf.files",
                                     "puppet:///named/common/recvconf.files" ],
                        owner   => root,
                        group   => root,
                        mode    => 444,
                        ;

                "/etc/ssh/userkeys/geodnssync":
                        source  => [ "puppet:///named/per-host/$fqdn/authorized_keys",
                                     "puppet:///named/common/authorized_keys" ],
                        owner   => root,
                        group   => geodnssync,
                        mode    => 440,
                        ;
        }
}

# vim: set fdm=marker ts=8 sw=8 et:
