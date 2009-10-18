class named::geodns inherits named {
        file {
                "/etc/apt/sources.list.d/geoip.list":
                        content => template("debian-org/etc/apt/sources.list.d/geoip.list.erb"),
                        notify  => Exec["apt-get update"],
                        ;
                "/etc/bind/named.conf.local":
                        source  => [ "puppet:///named/per-host/$fqdn/named.conf.local",
                                     "puppet:///named/per-host/named.conf.local" ],
                        require => Package["bind9"],
                        notify  => Exec["bind9 restart"],
                        owner   => root,
                        group   => root,
                        ;
                "/etc/bind/named.conf.acl":
                        source  => [ "puppet:///named/per-host/$fqdn/named.conf.acl",
                                     "puppet:///named/per-host/named.conf.acl" ],
                        require => Package["bind9"],
                        notify  => Exec["bind9 restart"],
                        owner   => root,
                        group   => root,
                        ;
                "/etc/bind/named.conf.options":
                        source  => [ "puppet:///named/per-host/$fqdn/named.conf.options",
                                     "puppet:///named/per-host/named.conf.options" ],
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
                                     "puppet:///named/per-host/named.conf.geo" ],
                        require => Package["bind9"],
                        notify  => Exec["bind9 restart"],
                        owner   => root,
                        group   => root,
                        ;
                "/etc/bind/geodns/recvconf":
                        source  => [ "puppet:///named/per-host/$fqdn/recvconf",
                                     "puppet:///named/per-host/recvconf" ],
                        owner   => root,
                        group   => root,
                        mode    => 555,
                        ;
                "/etc/bind/geodns/recvconf.files":
                        source  => [ "puppet:///named/per-host/$fqdn/recvconf.files",
                                     "puppet:///named/per-host/recvconf.files" ],
                        owner   => root,
                        group   => root,
                        mode    => 444,
                        ;

                "/usr/share/GeoIP/GeoIPv6.dat":
                        source  => [ "puppet:///named/per-host/$fqdn/GeoIPv6.dat",
                                     "puppet:///named/per-host/GeoIPv6.dat" ],
                        owner   => root,
                        group   => root,
                        mode    => 444,
                        ;

                "/etc/ssh/userkeys/geodnssync":
                        source  => [ "puppet:///named/per-host/$fqdn/authorized_keys",
                                     "puppet:///named/per-host/authorized_keys" ],
                        owner   => root,
                        group   => geodnssync,
                        mode    => 440,
                        ;
                "/var/log/bind9":
                        ensure  => directory,
                        owner   => bind,
                        group   => bind,
                        mode    => 775,
                        ;
        }
}

# vim: set fdm=marker ts=8 sw=8 et:
