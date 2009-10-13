class geodns {

        package {
                bind9: ensure => installed;
        }

        file {
                "/etc/apt/sources.list.d/geoip.list":
                        content => template("debian-org/etc/apt/sources.list.d/geoip.list.erb"),
                        notify  => Exec["apt-get update"],
                        ;
                "/etc/bind/named.conf.local":
                        source  => [ "puppet:///geodns/per-host/$fqdn/named.conf.local",
                                     "puppet:///geodns/common/named.conf.local" ],
                        require => Package["bind9"],
                        notify  => Exec["bind9 restart"],
                        owner   => root,
                        group   => root,
                        ;
                "/etc/bind/named.conf.acl":
                        source  => [ "puppet:///geodns/per-host/$fqdn/named.conf.acl",
                                     "puppet:///geodns/common/named.conf.acl" ],
                        require => Package["bind9"],
                        notify  => Exec["bind9 restart"],
                        owner   => root,
                        group   => root,
                        ;
                "/etc/bind/named.conf.options":
                        source  => [ "puppet:///geodns/per-host/$fqdn/named.conf.options",
                                     "puppet:///geodns/common/named.conf.options" ],
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
                        source  => [ "puppet:///geodns/per-host/$fqdn/named.conf.geo",
                                     "puppet:///geodns/common/named.conf.geo" ],
                        require => Package["bind9"],
                        notify  => Exec["bind9 restart"],
                        owner   => root,
                        group   => root,
                        ;
                "/etc/bind/geodns/recvconf":
                        source  => [ "puppet:///geodns/per-host/$fqdn/recvconf",
                                     "puppet:///geodns/common/recvconf" ],
                        owner   => root,
                        group   => root,
                        mode    => 555,
                        ;
                "/etc/bind/geodns/recvconf.files":
                        source  => [ "puppet:///geodns/per-host/$fqdn/recvconf.files",
                                     "puppet:///geodns/common/recvconf.files" ],
                        owner   => root,
                        group   => root,
                        mode    => 444,
                        ;

                "/usr/share/GeoIP/GeoIPv6.dat":
                        source  => [ "puppet:///geodns/per-host/$fqdn/GeoIPv6.dat",
                                     "puppet:///geodns/common/GeoIPv6.dat" ],
                        owner   => root,
                        group   => root,
                        mode    => 444,
                        ;

                "/etc/ssh/userkeys/geodnssync":
                        source  => [ "puppet:///geodns/per-host/$fqdn/authorized_keys",
                                     "puppet:///geodns/common/authorized_keys" ],
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

        exec {
                "bind9 restart":
                        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
                        refreshonly => true,
                        ;
        }
}

# vim: set fdm=marker ts=8 sw=8 et:
